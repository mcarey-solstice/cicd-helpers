
.. |MAN_SECTION| replace:: 1

.. |DESCRIPTION| replace::
  Calculates the next version.  If a patch version is apparent, the patch version will become the default bump; otherwise, the minor version will become the default bump.

.. |OPTION_MAJOR| replace::
  Indicates to bump the major version.  The patch and minor version will be reset to zero and any rc version will be removed.

.. |OPTION_MINOR| replace::
  Indicates to bump the minor version.  The patch version will be reset to zero and any rc version will be removed.

.. |OPTION_PATCH| replace::
  Indicates to bump the patch version.  If any rc version will be removed.

.. |OPTION_RC| replace::
  Indicates to bump the rc version.  If no rc version is apparent, the rc identifier will be added, the version will be set to 1, and the minor version (or patch version) will be incremented by 1; otherwise, the rc version is simply bumped.

.. |OPTION_HELP| replace:: \
