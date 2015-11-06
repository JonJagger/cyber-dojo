#!/bin/bash

sudo -u cyber-dojo docker-machine ssh cdf-01 -- sudo tail -3 /var/log/rsyncd.log
sudo -u cyber-dojo docker-machine ssh cdf-02 -- sudo tail -3 /var/log/rsyncd.log
sudo -u cyber-dojo docker-machine ssh cdf-03 -- sudo tail -3 /var/log/rsyncd.log

