#!/usr/bin/env bash

source .scripts/logging_utils.sh

set -x

startgroup "Installing a fresh version of Miniforge"
MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download"
MINIFORGE_FILE="Miniforge3-MacOSX-x86_64.sh"
curl -L -O "${MINIFORGE_URL}/${MINIFORGE_FILE}"
bash $MINIFORGE_FILE -b
endgroup "Installing a fresh version of Miniforge"

startgroup "Configuring conda"
BUILD_CMD=build

source ${HOME}/miniforge3/etc/profile.d/conda.sh
conda activate base

echo -e "\n\nInstalling conda-forge-ci-setup=3 and conda-build."
conda install -n base --quiet --yes "conda-forge-ci-setup=3" conda-build pip ${GET_BOA:-}



echo -e "\n\nSetting up the condarc and mangling the compiler."
setup_conda_rc ./ ./recipe ./.ci_support/${CONFIG}.yaml
mangle_compiler ./ ./recipe .ci_support/${CONFIG}.yaml

echo -e "\n\nMangling homebrew in the CI to avoid conflicts."
/usr/bin/sudo mangle_homebrew
/usr/bin/sudo -k

echo -e "\n\nRunning the build setup script."
source run_conda_forge_build_setup


endgroup "Configuring conda"

set -e

startgroup "Running conda $BUILD_CMD"
echo -e "\n\nMaking the build clobber file"
make_build_number ./ ./recipe ./.ci_support/${CONFIG}.yaml

conda $BUILD_CMD ./recipe -m ./.ci_support/${CONFIG}.yaml --suppress-variables --clobber-file ./.ci_support/clobber_${CONFIG}.yaml ${EXTRA_CB_OPTIONS:-}
endgroup "Running conda build"
startgroup "Validating outputs"
validate_recipe_outputs "${FEEDSTOCK_NAME}"
endgroup "Validating outputs"

if [[ "${UPLOAD_PACKAGES}" != "False" ]]; then
  startgroup "Uploading packages"
  upload_package --validate --feedstock-name="${FEEDSTOCK_NAME}" ./ ./recipe ./.ci_support/${CONFIG}.yaml
  endgroup "Uploading packages"
fi