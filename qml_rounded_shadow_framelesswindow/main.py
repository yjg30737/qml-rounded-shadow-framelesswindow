import sys, os

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

def showQml():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    p = os.path.dirname(__file__)
    engine.load(os.path.join(p, 'main.qml'))
    sys.exit(app.exec())