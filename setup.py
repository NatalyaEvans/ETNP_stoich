from setuptools import find_packages
from distutils.core import setup

if __name__== '__main__':
    setup(include_package_data=True,
          description='Scripts specific to ETNP_WOD_pyompa',
          long_description="""Scripts specific to ETNP_WOD_pyompa""",
          author="Natalya Evans, but basically Avanti Shrikumar",
          author_email="ncevans@usc.edu",
          url='https://github.com/NatalyaEvans/ETNP_stoich',
          version='0.1.0.0',
          packages=find_packages(),
          setup_requires=[],
          install_requires=['gsw', 'pyompa'],
          scripts=[],
          name='pyompa_scripts')
