# Evernote Data Source for the Ruby web publishing system nanoc

A `Nanoc::DataSource` for loading site data items from an [Evernote][evernote] notebook. 

## Features

- Loads Evernote notes from a specified notebook to create Nanoc Items.

- Does very simple Nokogiri XML conversion to output HTML.

## RubyGems dependencies 

- [Evernote Ruby SDK][evernote-ruby-sdk], the Evernote API for Ruby:
  
    `sudo gem install evernote-thrift`

## Usage

Copy the file `lib/nanoc/data_sources/evernote_thrift.rb` into your site `lib/nanoc/data_sources` folder.    

## Open Issues

- Conversion has to be improved.

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