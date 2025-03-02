#!/bin/sh
set -e

# Cargar las dependencias
bundle exec sidekiq -r ./sidekiq_init.rb -C config/sidekiq.yml
