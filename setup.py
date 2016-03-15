from setuptools import setup
import pywebgettext

setup(
    name='pywebgettext',
    version=pywebgettext.__version__,
    py_modules = ['pywebgettext'],
    author="Vincent MAILLOL",
    author_email="pywebgettext@gmail.com",
    description="Extract gettext strings from python template",
    long_description=open('README.rst').read(),
    url='http://github.com/maillol/pywebgettext',
 
    classifiers=[
        "Programming Language :: Python",
        "Development Status :: 1 - Planning",
        "Natural Language :: French",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3.4",
        "Topic :: Software Development :: Internationalization"
    ],
 
    entry_points = {
        'console_scripts': [
            'pywebgettext = pywebgettext',
        ],
    },
    license="WTFPL"
)
