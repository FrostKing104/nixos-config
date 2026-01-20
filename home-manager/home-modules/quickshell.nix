{ pkgs, config, ... }:

{
  xdg.configFile."noctalia/custom/HyprInfo.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Hyprland

    ShellRoot {
        Variants {
            model: Quickshell.screens
            delegate: PanelWindow {
                screen: modelData
                
                // In 0.2.1, PanelWindow uses bitmask-style anchors.
                // To center horizontally, you anchor to both left and right.
                anchors.top: true
                anchors.left: true
                anchors.right: true
                
                // We set a fixed height for the window, 
                // but the width will be controlled by the margins or the layout.
                height: layout.height
                color: "transparent"

                Rectangle {
                    id: layout
                    // Center the rectangle within the full-width transparent window
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    width: 150
                    height: 40
                    color: "#1e1e2e" 
                    radius: 8
                    border.color: "#89b4fa"
                    border.width: 2

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Text { 
                            text: "WS:" 
                            color: "#f5e0dc" 
                            font.bold: true 
                            font.pixelSize: 14
                        }

                        Text { 
                            text: Hyprland.focusedWorkspace.name
                            color: "white"
                            font.family: "JetBrains Mono"
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }
  '';
}
