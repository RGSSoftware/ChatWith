#!/bin/bash


#add all file in dir to staging area
git add *

#commit staging area with message from first Argument "$1"
git commit -m "$1"

#push {send}new commits on local branch to remote{github}
git push github HEAD
