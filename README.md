<h1 align="center">
  <img src="DS-Store-Remover/Assets.xcassets/AppIcon.appiconset/Untitled-macOS-Default-512x512@2x.png" alt="DS-Store-Remover" width="128" />
</h1>

<h3 align="center">
DS-Store-Remover for macOS
</h3>

## Preview
![](Image1.png)
![](Image2.png)

## The application can't be opened
![](Image3.png)
```bash
sudo xattr -cr /Applications/Ds-Store-Remover
```

## Other Methods to Remove .DS_Store Files
```bash
cd /Users/administrator/Documents
find . -name .DS_Store -type f -delete
```
