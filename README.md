# Batali TK

Batali for test-kitchen!

## Usage

Batali support must be injected into test-kitchen. This is done by using
a wrapper command. Instead of calling kitchen directly:

```
$ kitchen --help
```

use the wrapper command:

```
$ batali-tk --help
```

### Infrastructure Repository

The Batali test-kitchen wrapper can be used to test cookbooks within an
infrastructure repository context. A `Batali` file is required at the root
of the infrastructure repository and is optional within the cookbook itself
(only required in the cookbook if extra testing dependencies are required).
This can be done using the `--batali-cookbook-path` flag. As most cookbooks
will live in a separate repository, you can provide the path to a working
copy on your system:

```
$ batali-tk test BOX --batali-cookbook-path ../users
```

#### Environment constraints

If you want to test the cookbook using a specific set of environment constraints,
that can be done too. It required the auto discovery feature of Batali to be
in use within the infrastructure repository Batali file. To enable environment
constraints:

```
$ batali-tk test BOX --batali-cookbook-path ../users --batali-environment production
```

# Info

* Repository: https://github.com/hw-labs/batali-tk
