# Python code

This directory contains Python code and notebooks that allow you to interact with Kùzu using its
Python API.

## Setup

The minimum recommended Python version is 3.10+. We also recommend using the `uv` package manager
to manage dependencies. You can install `uv` using the following commands:

```bash
# On macOS and Linux.
curl -LsSf https://astral.sh/uv/install.sh | sh

# On Windows.
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

It's also recommended to set up a clean virtual environment before installing any dependencies.

```bash
# Create a virtual environment at .venv
uv venv

# On macOS and Linux
source .venv/bin/activate

# On Windows
.venv\Scripts\activate
```

Once you have the virtual environment set up, you can install the dependencies using
the provided `requirements.txt` file.

```bash
uv pip install -r requirements.txt
```

For this workshop, we will use the dev version of Kùzu, as we want to work with its latest features.
You can install the dev version using the following command:

```bash
uv pip install --pre kuzu
```

> [!NOTE]
> For your production work, do not use the dev version of Kùzu. Instead, use the latest stable version
> by running `pip install kuzu`.
