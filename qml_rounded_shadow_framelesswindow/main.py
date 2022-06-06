import sys, os

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QTimer, QObject, pyqtSignal

from time import strftime, localtime


def showQml():
    class Backend(QObject):
        updated = pyqtSignal(str, arguments=['time'])

        def __init__(self):
            super().__init__()

            # Define timer.
            self.timer = QTimer()
            self.timer.setInterval(100)  # msecs 100 = 1/10th sec
            self.timer.timeout.connect(self.update_time)
            self.timer.start()

        def update_time(self):
            # Pass the current time to QML.
            curr_time = strftime("%H:%M:%S", localtime())
            self.updated.emit(curr_time)

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    p = os.path.dirname(__file__)
    engine.load(os.path.join(p, 'main.qml'))

    # Define our backend object, which we pass to QML.
    backend = Backend()
    engine.rootObjects()[0].setProperty('backend', backend)
    # Initial call to trigger first update. Must be after the setProperty to connect signals.
    backend.update_time()

    sys.exit(app.exec())