#!/bin/bash

echo "Restarting Puma server..."
sudo systemctl restart puma
sudo systemctl status puma
echo "DONE"
echo "Restarting Nginx server..."
sudo systemctl restart nginx
sudo systemctl status nginx
echo "DONE"