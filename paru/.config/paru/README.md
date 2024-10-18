# Packages

1; Query the packages explicitly installed from the sync db(s)

```bash
paru -Qenq > packages.txt # Without version information
paru -Qen > packages.txt # With version information
```

2; Query the packages explicitly installed from AUR

```bash
paru -Qemq > aur-packages.txt # Without version information
paru -Qem > aur-packages.txt # With version information
```
