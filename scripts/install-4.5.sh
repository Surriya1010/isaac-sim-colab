# This script is intended to be used with a specially modified Colab notebook.
# i.e., https://colab.research.google.com/github/j3soon/isaac-sim-colab/blob/main/notebooks/minimal.ipynb
# For more information, see: https://github.com/j3soon/isaac-sim-colab.

# Download and execute Python 3.10 set up script
# Ref: https://github.com/j3soon/colab-python-version
wget -O py310.sh https://raw.githubusercontent.com/j3soon/colab-python-version/main/scripts/py310.sh
bash py310.sh

# Set up Vulkan runtime dependencies
apt-get install -y vulkan-tools
# Ref: https://askubuntu.com/a/575808
apt-get install -y libglu1
# Ref: https://stackoverflow.com/a/72736003
conda install -y gcc=12.1.0 -c conda-forge
# Ref: https://github.com/j3soon/docker-vulkan-runtime
cat > /etc/vulkan/icd.d/nvidia_icd.json <<EOF
{
    "file_format_version" : "1.0.0",
    "ICD": {
        "library_path": "libGLX_nvidia.so.0",
        "api_version" : "1.3.194"
    }
}
EOF
mkdir -p /usr/share/glvnd/egl_vendor.d && \
    cat > /usr/share/glvnd/egl_vendor.d/10_nvidia.json <<EOF
{
    "file_format_version" : "1.0.0",
    "ICD" : {
        "library_path" : "libEGL_nvidia.so.0"
    }
}
EOF
cat > /etc/vulkan/implicit_layer.d/nvidia_layers.json <<EOF
{
    "file_format_version" : "1.0.0",
    "layer": {
        "name": "VK_LAYER_NV_optimus",
        "type": "INSTANCE",
        "library_path": "libGLX_nvidia.so.0",
        "api_version" : "1.3.194",
        "implementation_version" : "1",
        "description" : "NVIDIA Optimus layer",
        "functions": {
            "vkGetInstanceProcAddr": "vk_optimusGetInstanceProcAddr",
            "vkGetDeviceProcAddr": "vk_optimusGetDeviceProcAddr"
        },
        "enable_environment": {
            "__NV_PRIME_RENDER_OFFLOAD": "1"
        },
        "disable_environment": {
            "DISABLE_LAYER_NV_OPTIMUS_1": ""
        }
    }
}
EOF
vulkaninfo

# Install Isaac Sim through pip.
# Ref: https://docs.isaacsim.omniverse.nvidia.com/latest/installation/install_python.html
pip install isaacsim[all]==4.5.0 isaacsim[extscache]==4.5.0 --extra-index-url https://pypi.nvidia.com

# Download Isaac Sim minimal example
wget -O isaac-sim-simulation-example.py https://raw.githubusercontent.com/j3soon/omni-farm-isaac/master/tasks/isaac-sim-simulation-example.py
