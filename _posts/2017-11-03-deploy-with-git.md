---
title: "Deploy with git"
layout: post
---

I can be real lazy when I want to be, and I’m laziest when it comes to things I’ve done a hundred times before. The more we repeat certain tasks, the more mundane it becomes, and that can lead to a sore spot during the workday.

I first started using this method of deployment when I wanted a more streamlined approach rather than using an ftp tool I jumped at the chance to combine that task with a tool I already use daily: Git. One of Git’s most overlooked features are it’s hooks. Git hooks are custom scripts that are fired when important events occur on a repository such as merging, committing, and rebasing.

With a little elbow grease up front, we can set up a simple workflow to deploy a website or even a web app with build commands to a production server.

### The Setup

For this example let’s assume `/var/www/domain.com` is our live site’s root directory, and `/var/repo/domain.git` will be our site’s git repository. I would recommend the repository be placed outside of a publicly accessible location.

```
ssh user@server.com
mkdir -p /var/repo/site.git
cd /var/repo/site.git
```

Now let’s create the git repository we will push changes to:

```
git init --bare
```

Using the --bare flag will create new empty repository complete with hooks and version control, but that’s it. We will be pushing the code to it later.
Get hooked

If you type `ls hooks/` in your new bare repository, you’ll find a number of sample hooks. There a few hooks not listed here, and are used only on remote repositories: update, pre-receive, and post-receive.

The post-receive hook is what we’ll be using to deploy. This hook will fire whenever a successful push is received, which is perfect for this scenario, but we’ll need to create it:

```
touch hooks/post-receive
```

Then, using your preferred method, let’s write the hook script:

```
#!/bash/sh
git \
--work-tree=/var/www/domain.com \
--git-dir=/var/repo/site.git \
checkout -f
```

This will tell git to checkout the pushed branch into our website’s root directory (defined using the --work-tree flag) and overwrite anything already there.

Don’t forget to set post-receive as executable (something I’ve done a few times):

```
chmod +x hooks/post-receive
```

Only one thing left to do.
On your local machine, add a remote pointed to the bare repository on your production server:

```
git remote add live ssh://user@domain.com/var/repo/site.git
```

Now, publishing committed changes are as simple as:

```
git push remote master
```

### Adding more flavor

Since a git hook is simply a bash script, we can execute other commands. I use a similar script to build a production version of a React app of mine. The app is pushed to my remote repository and the post-receive hook will run the build commands needed.

```
#!/bash/sh
echo "Pushing changes to web root..."
git \
--work-tree=/var/www/domain.com \
--git-dir=/var/repo/site.git \
checkout -f

echo "Building..."
cd /var/www/domain.com
npm run build && forever restart server.js
```

Forever is a package to keep your node apps persistent.

It can be argued that using git in this way is an anti-pattern, and that’s true. Git is not a deployment tool, and should not be used in large applications. However, simplifying your workflow for those smaller projects is great!