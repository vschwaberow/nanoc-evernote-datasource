# encoding: utf-8

require 'evernote-thrift'
require 'nokogiri'
require 'debugger'

module Nanoc::DataSources
	


	class EvernoteThrift < Nanoc::DataSource

		identifier :evernote
	
		def items
			@items ||= begin

				if self.config[:host].nil?
					raise RuntimeError, "Evernote Host is required [Sandbox or productive environment]."
				end
				if self.config[:authtoken].nil?
					raise RuntimeError, "Evernote requires an authorization token."
				end
				if self.config[:notebook].nil?
					raise RuntimeError, "It is required to define a notebook as data source."
				end
							
				evernoteHost = self.config[:host]
				userStoreUrl = "https://#{evernoteHost}/edam/user"
				authToken = self.config[:authtoken]
				notebook_name = self.config[:notebook]

				filter = Evernote::EDAM::NoteStore::NoteFilter.new
				
				userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
				userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
				userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)
				
				versionOK = userStore.checkVersion("Evernote EDAMTest (Ruby)",
				Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
				Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
				if versionOK.nil?
					raise RuntimeError, "Evernote SDK version not okay."
				end
				
				noteStoreUrl = userStore.getNoteStoreUrl(authToken)
				
				noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
				noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
				noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

				notebooks = noteStore.listNotebooks(authToken)
				
				notebook = notebooks.find { | e | e.name == notebook_name} 	
				filter.notebookGuid = notebook.guid
				notebook_count = noteStore.findNoteCounts(authToken, filter, false)
				
				var = []
				notebook_count.notebookCounts.map { | k,v |	var = v }
				notebook_count = var
							
				notes = noteStore.findNotes(authToken,filter,0,notebook_count)
				
				raw_items = Array.new
				
				notes.notes.each do | i |
					note = noteStore.getNote(authToken, i.guid, true, false, false, false)
					attributes = Array.new

					attributes = {
						:title => note.title,
						:guid => note.guid,
						:content => note.content,
						:created => note.created,
						:updated => note.updated,

					}
					raw_items.push attributes

				end


				items = Array.new

				raw_items.each_with_index.map do | raw_item, i |
			
					doc = Nokogiri::XML(raw_item[:content])
					content = (doc/"en-note").text
			
					attributes = {
						:created_at => Time.at(raw_item[:created] / 1000),
						:source => raw_item[:title]
					}
					
					id = "/#{raw_item[:title]}/"

					
					items.push Nanoc::Item.new(content, attributes, id)
				end
				items 
			
				
			end


		end

			
	end
	
end