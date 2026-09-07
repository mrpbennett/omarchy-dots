import QtQuick
import QtQuick.Effects
import qs.Commons

Item {
  id: root

  property string backgroundPath: ""
  property int backgroundVersion: 0
  property string avatarPath: ""
  property string displayName: ""
  property bool fingerprintConfigured: false
  property string fingerprintStatus: "unavailable"
  property bool authenticatingPassword: false
  property string failureMessage: ""
  property int failedAttempts: 0
  property bool inputEnabled: true
  property bool loadBackground: true
  property string passwordText: ""
  property bool syncingPasswordText: false
  property date currentTime: new Date()

  readonly property int fieldWidth: Math.round(Math.min(380, Math.max(280, width * 0.32)))
  readonly property int fieldHeight: 48
  readonly property int fieldFontSize: Math.round(Style.font.body * 1.05)
  readonly property int passwordDotFontSize: Math.round(Style.font.title * 1.05)
  readonly property int passwordDotLetterSpacing: Math.round(Style.font.body * 0.16)
  readonly property string clockFormat: {
    var localeFormat = Qt.locale().timeFormat(Locale.ShortFormat)
    return localeFormat.replace(/([:.])s{1,2}/g, "")
  }
  readonly property bool errorState: failureMessage.length > 0
  readonly property bool showPasswordCursor: inputEnabled && !authenticatingPassword && !errorState
  readonly property real passwordDotScale: dotMetrics.advanceWidth > 0
    ? Math.min(1, (passwordInput.width - 4) / dotMetrics.advanceWidth)
    : 1
  readonly property string fingerprintMessage: {
    if (!fingerprintConfigured) return ""
    if (fingerprintStatus === "retrying") return "Fingerprint not recognized. Try again."
    if (fingerprintStatus === "checking") return "Checking fingerprint…"
    return "Use fingerprint or enter password"
  }
  readonly property string statusMessage: {
    if (failureMessage.length > 0) return failureMessage
    if (authenticatingPassword) return "Checking password…"
    return fingerprintMessage
  }

  signal submitPassword(string password)
  signal passwordTextEdited(string password)
  signal clearFailureRequested()
  signal wakeRequested()

  function fileUrl(path, version) {
    if (!path) return ""
    var encoded = String(path).split("/").map(encodeURIComponent).join("/")
    return "file://" + encoded + (version === undefined ? "" : "?v=" + version)
  }

  function forcePasswordFocus() {
    passwordInput.forceActiveFocus()
  }

  function syncPasswordText() {
    if (passwordInput.text === passwordText) return
    syncingPasswordText = true
    passwordInput.text = passwordText
    syncingPasswordText = false
  }

  onPasswordTextChanged: syncPasswordText()
  onInputEnabledChanged: {
    if (inputEnabled) Qt.callLater(forcePasswordFocus)
  }
  onFailureMessageChanged: {
    if (failureMessage.length > 0) failureShake.restart()
  }
  Component.onCompleted: {
    syncPasswordText()
    if (inputEnabled) Qt.callLater(forcePasswordFocus)
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.currentTime = new Date()
  }

  TextMetrics {
    id: dotMetrics
    font.family: Style.font.family
    font.pixelSize: root.passwordDotFontSize
    font.letterSpacing: root.passwordDotLetterSpacing
    text: "●".repeat(passwordInput.text.length)
  }

  Rectangle {
    anchors.fill: parent
    color: Color.background

    Image {
      id: wallpaper
      anchors.fill: parent
      source: root.loadBackground ? root.fileUrl(root.backgroundPath, root.backgroundVersion) : ""
      fillMode: Image.PreserveAspectCrop
      asynchronous: true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
    }

    Rectangle {
      anchors.fill: parent
      color: "#46000000"
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked: { root.wakeRequested(); root.forcePasswordFocus() }
      onPositionChanged: root.wakeRequested()
    }

    Column {
      id: clock
      anchors.top: parent.top
      anchors.topMargin: Math.round(Math.min(128, Math.max(48, parent.height * 0.1)))
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: Math.round(Math.max(4, parent.height * 0.006))

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatTime(root.currentTime, root.clockFormat)
        color: Color.lock.text
        font.family: Style.font.family
        font.pixelSize: Math.round(Math.min(132, Math.max(64, root.height * 0.105)))
        font.weight: Font.ExtraLight
        style: Text.Raised
        styleColor: "#50000000"
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatDate(root.currentTime, Locale.LongFormat)
        color: Color.lock.text
        font.family: Style.font.family
        font.pixelSize: Math.round(Math.min(26, Math.max(17, root.height * 0.024)))
        font.weight: Font.Medium
        style: Text.Raised
        styleColor: "#50000000"
      }
    }

    Column {
      id: authPanel

      width: root.fieldWidth
      anchors.bottom: parent.bottom
      anchors.bottomMargin: Math.round(Math.min(100, Math.max(40, parent.height * 0.07)))
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: Math.round(Math.min(16, Math.max(10, parent.height * 0.014)))

      Item {
        id: avatar
        width: Math.round(Math.min(96, Math.max(72, root.height * 0.09)))
        height: width
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
          anchors.fill: parent
          radius: width / 2
          color: "#66ffffff"
          border.width: 1
          border.color: "#80ffffff"

          Rectangle {
            width: parent.width * 0.31
            height: width
            radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.18
            color: "#d9ffffff"
          }

          Rectangle {
            width: parent.width * 0.62
            height: parent.height * 0.32
            radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.12
            color: "#d9ffffff"
          }
        }

        Item {
          id: avatarMask
          anchors.fill: parent
          visible: false
          layer.enabled: true

          Rectangle {
            anchors.fill: parent
            radius: width / 2
          }
        }

        Image {
          id: avatarImage
          anchors.fill: parent
          source: root.fileUrl(root.avatarPath)
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          cache: false
          visible: status === Image.Ready
          layer.enabled: visible
          layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: avatarMask
          }
        }
      }

      Text {
        width: parent.width
        text: root.displayName
        color: Color.lock.text
        font.family: Style.font.family
        font.pixelSize: Math.round(Style.font.title * 1.05)
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        style: Text.Raised
        styleColor: "#50000000"
      }

      Rectangle {
        id: inputField
        property real shakeOffset: 0

        width: parent.width
        height: root.fieldHeight
        radius: height / 2
        color: "#59ffffff"
        border.width: root.errorState || passwordInput.activeFocus ? 2 : 1
        border.color: root.errorState
          ? Color.lock.borderError
          : (passwordInput.activeFocus ? Color.lock.borderActive : "#80ffffff")
        transform: Translate { x: inputField.shakeOffset }

        TextInput {
          id: passwordInput
          anchors.fill: parent
          anchors.leftMargin: 22
          anchors.rightMargin: root.fingerprintConfigured ? 48 : 22
          verticalAlignment: TextInput.AlignVCenter
          horizontalAlignment: TextInput.AlignHCenter
          activeFocusOnPress: true
          clip: true
          enabled: root.inputEnabled && !root.authenticatingPassword
          readOnly: root.authenticatingPassword
          echoMode: TextInput.Password
          passwordCharacter: "\u25CF"
          passwordMaskDelay: 0
          color: Color.lock.text
          selectionColor: Color.lock.selection
          selectedTextColor: Color.lock.text
          font.family: Style.font.family
          font.pixelSize: text.length > 0
            ? Math.max(1, Math.floor(root.passwordDotFontSize * root.passwordDotScale))
            : root.fieldFontSize
          font.letterSpacing: text.length > 0 ? root.passwordDotLetterSpacing * root.passwordDotScale : 0
          cursorVisible: activeFocus && root.showPasswordCursor && text.length > 0
          cursorDelegate: Rectangle {
            width: 2
            color: Color.lock.text
            visible: passwordInput.cursorVisible
          }

          onTextChanged: {
            if (!root.syncingPasswordText) root.passwordTextEdited(text)
            if (text.length > 0) root.wakeRequested()
            if (text.length > 0 && root.failureMessage.length > 0) root.clearFailureRequested()
          }

          onAccepted: {
            var submitted = root.passwordText
            root.passwordTextEdited("")
            if (submitted.length > 0) root.submitPassword(submitted)
          }

          Keys.onPressed: function(event) {
            root.wakeRequested()
            if (event.key === Qt.Key_Escape || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_U)) {
              root.passwordTextEdited("")
              event.accepted = true
            }
          }
        }

        Text {
          anchors.fill: passwordInput
          text: root.authenticatingPassword ? "Checking…" : "Enter Password"
          visible: passwordInput.text.length === 0
          color: Color.lock.placeholder
          font.family: Style.font.family
          font.pixelSize: root.fieldFontSize
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          elide: Text.ElideRight
        }

        Text {
          anchors.right: parent.right
          anchors.rightMargin: 17
          anchors.verticalCenter: parent.verticalCenter
          visible: root.fingerprintConfigured
          text: "󰈷"
          color: root.fingerprintStatus === "retrying" ? Color.lock.textError : Color.lock.text
          font.family: Style.font.family
          font.pixelSize: Math.round(root.fieldFontSize * 1.1)
        }
      }

      Text {
        width: parent.width
        height: Math.max(implicitHeight, Math.round(Style.font.bodySmall * 1.5))
        text: root.statusMessage
        visible: text.length > 0
        color: root.errorState || root.fingerprintStatus === "retrying"
          ? Color.lock.textError
          : Color.lock.text
        font.family: Style.font.family
        font.pixelSize: Style.font.bodySmall
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        elide: Text.ElideRight
        style: Text.Raised
        styleColor: "#50000000"
      }
    }
  }

  SequentialAnimation {
    id: failureShake
    NumberAnimation { target: inputField; property: "shakeOffset"; to: -8; duration: 45 }
    NumberAnimation { target: inputField; property: "shakeOffset"; to: 7; duration: 55 }
    NumberAnimation { target: inputField; property: "shakeOffset"; to: -5; duration: 55 }
    NumberAnimation { target: inputField; property: "shakeOffset"; to: 3; duration: 50 }
    NumberAnimation { target: inputField; property: "shakeOffset"; to: 0; duration: 45 }
  }
}
