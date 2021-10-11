import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import "Buttons"
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5

MainView {
  id:window
  objectName: "mainView"
  theme.name: "Ubuntu.Components.Themes.SuruDark"

  applicationName: "kuketz"


  backgroundColor : "#ffffff"





  WebView {
    id: webview
    anchors{ fill: parent}

    enableSelectOverride: true


    settings.fullScreenSupportEnabled: true
    property var currentWebview: webview
    settings.pluginsEnabled: true

    onFullScreenRequested: function(request) {
      nav.visible = !nav.visible
      request.accept();
    }



    profile:  WebEngineProfile{
      id: webContext
      persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
      property alias dataPath: webContext.persistentStoragePath

      dataPath: dataLocation



      httpUserAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36"
    }

    anchors{
      fill:parent
    }

    url: "https://www.kuketz-blog.de/"
    userScripts: [
      WebEngineScript {
        injectionPoint: WebEngineScript.DocumentReady
        worldId: WebEngineScript.MainWorld
        name: "QWebChannel"
        sourceUrl: "ubuntutheme.js"
      }
    ]


  }
  RadialBottomEdge {
    id: nav
    visible: true
    actions: [

    RadialAction {
      id: start
      iconSource: Qt.resolvedUrl("icons/home.png")
      onTriggered: {
        webview.url = "https://www.kuketz-blog.de/"
      }
      text: qsTr("Start")
      },
      RadialAction {
        id: forum
        iconSource: Qt.resolvedUrl("icons/forum.png")
        onTriggered: {
          webview.url = "https://forum.kuketz-blog.de/"
        }
        text: qsTr("Forum")
      },
      RadialAction {
        id: forward
        enabled: webview.canGoForward
        iconName: "go-next"
        onTriggered: {
          webview.goForward()
        }
        text: qsTr("Vorwärts")
      },
      RadialAction {
        id: chat
        iconSource: Qt.resolvedUrl("icons/chat.png")
        onTriggered: {
          webview.url = "https://www.kuketz-blog.de/chat/"
        }
        text: qsTr("Chat")
      },
      RadialAction {
        id: ecke
        iconSource: Qt.resolvedUrl("icons/ecke.png")
        onTriggered: {
          webview.url = "https://www.kuketz-blog.de/empfehlungsecke/"
        }
        text: qsTr("Empfehlungen")
      },
      RadialAction {
        id: themen
        iconSource: Qt.resolvedUrl("icons/thema.png")
        onTriggered: {
          webview.url = "https://www.kuketz-blog.de/slugmap/"
        }
        text: qsTr("Themen")
      },
      RadialAction {
        id: back
        enabled: webview.canGoBack
        iconName: "go-previous"
        onTriggered: {
          webview.goBack()
        }
        text: qsTr("Zurück")
      },
      RadialAction {
        id: microblog
        iconSource: Qt.resolvedUrl("icons/micro-blog.png")
        onTriggered: {
          webview.url = "https://www.kuketz-blog.de/category/microblog/"
        }
        text: qsTr("Microblog")

      }
    ]
  }

  Connections {
    target: Qt.inputMethod
    onVisibleChanged: nav.visible = !nav.visible
  }

  Connections {
    target: webview

    onIsFullScreenChanged: {
      window.setFullscreen()
      if (currentWebview.isFullScreen) {
        nav.state = "hidden"
      }
      else {
        nav.state = "shown"
      }
    }

  }

  Connections {
    target: webview

    onIsFullScreenChanged: window.setFullscreen(webview.isFullScreen)
  }
  function setFullscreen(fullscreen) {
    if (!window.forceFullscreen) {
      if (fullscreen) {
        if (window.visibility != Window.FullScreen) {
          internal.currentWindowState = window.visibility
          window.visibility = 5
        }
      } else {
        window.visibility = internal.currentWindowState
        //window.currentWebview.fullscreen = false
        //window.currentWebview.fullscreen = false
      }
    }
  }

  Connections {
    target: UriHandler

    onOpened: {

      if (uris.length > 0) {
        console.log('Incoming call from UriHandler ' + uris[0]);
        webview.url = uris[0];
      }
    }
  }



  ScreenSaver {
    id: screenSaver
    screenSaverEnabled: !(Qt.application.active) || !webview.recentlyAudible
  }
}
