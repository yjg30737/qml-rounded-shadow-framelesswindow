from setuptools import setup, find_packages

setup(
    name='qml-rounded-shadow-framelesswindow',
    version='0.0.6',
    author='Jung Gyu Yoon',
    author_email='yjg30737@gmail.com',
    license='MIT',
    packages=find_packages(),
    package_data={'qml_rounded_shadow_framelesswindow': ['main.qml'],
                  'qml_rounded_shadow_framelesswindow.images': ['peace.svg']},
    description='Rounded shadow frameless window made out of qml, execute with PyQt5',
    url='https://github.com/yjg30737/qml-rounded-shadow-framelesswindow.git',
    install_requires=[
        'PyQt5>=5.8'
    ]
)