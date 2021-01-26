# matrix-archive

Archive Matrix room messages.

Creates a YAML log of all room messages, including media.

# Installation

Note that at least Python 3.8+ is required.

1. Install [libolm](https://gitlab.matrix.org/matrix-org/olm) 3.1+

    - Debian 11+ (testing/sid) or Ubuntu 19.10+: `sudo apt install libolm-dev`

    - Archlinux based distribution can install the `libolm` package from the Community repository

    - macOS `brew install libolm`

    - Failing any of the above refer to the [olm
      repo](https://gitlab.matrix.org/matrix-org/olm) for build instructions.

2. Clone the repo and install dependencies
    ```
    git clone git@github.com:russelldavies/matrix-archive.git
    cd matrix-archive
    # Optional: create a virtualenv
    python -m venv venv && source venv/bin/activate
    pip install -r requirements.txt
    ```

# Setup

1. Download your E2E room keys: in the client Element you can do this by
   clicking on your profile icon, _Security & privacy_, _Export E2E room keys_.

   The file can be placed on:
   * .env directory under the name @id.keys
   * anyway (provide the path with --keys)
   * in /tmp to be copied by the script itself

# Bulk Backup

2. Run export.sh with the following parameters:
	```
      export.sh --user=USERID --password=USERPASS --keys=KEYFILES --keyspass=KEYSPASS --server=SERVER URL [--media | --no-media ] --all-rooms
	```
3. You will get your archive in a tgz format

# List rooms

2. Add `--list-rooms` instead of `--all-rooms` will generate a list of room id
You can then replace all rooms option by a series of `--room=` followed by the room id without the initial ! such as in:

```
/export.sh --user=my user --password=mypassword --keys=keyfile --keyspass=keypass --server=serverurl --room="NStMnAUWAIfVdYHsAm" --room="btYyveaTqxTRUbFSAj"
```

A file named `.env/room_list.@userid.txt` will be create with the ids you can use later

# Interactive selection of rooms

Add `--my-rooms` to reload the same rooms as previously selected. If no rooms file is found, the list will be displayed for selection (similar to List rooms above)

```
/export.sh --user=my user --password=mypassword --keys=keyfile --keyspass=keypass --server=serverurl --my-rooms
```

# Where is the backup ?

The backup archive is put in `.target` directory under the name `user_id.tgz`

