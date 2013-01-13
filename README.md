# Evernote Data Source for the Ruby web publishing system nanoc

A `Nanoc::DataSource` for loading site data items from an [Evernote][evernote] notebook. 

## Features

- Loads Evernote notes from a specified notebook to create Nanoc Items.

## RubyGems dependencies 

- [Evernote Ruby SDK][evernote-ruby-sdk], the Evernote API for Ruby:
  
    `sudo gem install evernote-thrift`

## Usage

Copy the file `lib/evernote.rb` into your site `lib` folder.    

## Open Issues

- Conversion of Evernote XML to yield output.

## Configuration

Example configuration for section `data sources` in `config.yaml`:

    data_sources:
      -
        # A data source for loading site data items from CouchDB server.
        type: evernote
        # Items generated into subdirectory
        items_root: /evernote
        config:
          # Evernote server (Sandbox or production)
          host: 'www.evernote.com'
          # Name of notebook entries should be generated from
          notebook: 'Blog'
          # Your Evernote authtoken
          authtoken: '<secret>'

[evernote]: http://www.evernote.com "Evernote"
[evernote-ruby-sdk]: https://github.com/evernote/evernote-sdk-ruby "Evernote Ruby SDK"