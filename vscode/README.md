## How to use

### update extensions.txt

```
$ code --list-extensions > extensions.txt
```

### install

```
$ cat extensions.txt | xargs -L 1 code --install-extension
```
