# -*- coding: utf-8 -*- 
import json
import os
import string

from git import Repo
from pprint  import pprint

dev_repo_file="/vagrant/shell_build_scripts/dev_repos.json"
indices_path='/home/vagrant/indices'

with open(dev_repo_file) as json_data:

    dev_repo = json.load(json_data)
    for i in dev_repo['git_repos']:
		#print(i['directory'])
		#print(i['url'])
		repo_directory = i['directory']
		repo_url = i['url']
		repo_path = os.path.join(indices_path, repo_directory)
		#print repo_path
		if not os.path.exists(repo_path):
			os.makedirs(repo_path)
		os.chdir(repo_path)
		Repo.clone_from(repo_url, repo_path)


