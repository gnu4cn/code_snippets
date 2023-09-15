# `git` 技巧

## About `git tag`

+ Add a tag and push it to remote

    - `git tag TAG_NAME`

    - `git tag TAG_NAME -a -m "message"`, Create an “annotated” tag with the given message (instead of prompting)

    - `git push origin TAG_NAME`

+ Delete local and remote tag

    - `git tag -d TAG_NAME`

    - `git push --delete origin TAG_NAME`

- List tags by commit date: `git tag --sort=committerdate`

