import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function nextSlide() {
        console.log("Next slide");
        presentation.goToNextSlide();
    }

    Timer {
        id: advanceTimer
        interval: 5000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            
            Column {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: "🍎 Добро пожаловать"
                    font.pixelSize: 48
                    color: "#cdd6f4"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    text: "macOS Liquid Arch устанавливается..."
                    font.pixelSize: 24
                    color: "#a6adc8"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            
            Column {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: "✨ Жидкое стекло"
                    font.pixelSize: 48
                    color: "#f5c2e7"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    text: "Прозрачность и blur эффекты по всей системе"
                    font.pixelSize: 20
                    color: "#a6adc8"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            
            Column {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: "🎨 Latte Dock"
                    font.pixelSize: 48
                    color: "#89dceb"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    text: "Док панель внизу с эффектом увеличения иконок"
                    font.pixelSize: 20
                    color: "#a6adc8"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            
            Column {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: "⌨️ Горячие клавиши"
                    font.pixelSize: 48
                    color: "#a6e3a1"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    text: "Meta - Launchpad | Meta+Q - Закрыть | Meta+Space - Поиск"
                    font.pixelSize: 18
                    color: "#a6adc8"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
