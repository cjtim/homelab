#!/bin/bash

ANSIBLE_CONFIG=ansible.cfg ansible-playbook site.yml -t ${tags:-"setup"}