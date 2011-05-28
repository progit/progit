# encoding: UTF-8

require 'rake/clean'


$lang = ENV['language']
$lang ||= 'en'

namespace :epub do
	TMP_DIR = File.join('epub', 'temp', $lang)
	INDEX_FILEPATH = File.join(TMP_DIR, 'progit.html')
	TARGET_FILEPATH = "progit-#{$lang}.epub"
	
	SOURCE_FILES = FileList.new(File.join($lang, '**', '*.markdown')).sort
	CONVERTED_MK_FILES = SOURCE_FILES.pathmap(File.join(TMP_DIR, '%f'))
	HTML_FILES = CONVERTED_MK_FILES.ext('html') 
	
	desc "generate EPUB ebook (add language=xx to build lang xx)"
	task :generate => :check
	task :generate => TARGET_FILEPATH
	
	desc "check whether all the required tools are installed"
	task :check do
		begin
			require 'maruku'
			found_maruku = true
		rescue LoadError
			found_maruku = false
		end
		
		$ebook_convert_cmd = ENV['ebook_convert_path'].to_s
		if $ebook_convert_cmd.empty?
			$ebook_convert_cmd = `which ebook-convert`.chomp
		end
		if $ebook_convert_cmd.empty?
			mac_osx_path = '/Applications/calibre.app/Contents/MacOS/ebook-convert'
			$ebook_convert_cmd = mac_osx_path
		end
		found_calibre = File.executable?($ebook_convert_cmd)
		
		if !found_maruku
			puts 'EPUB generation requires the Maruku gem.'
			puts '  On Ubuntu call "sudo apt-get install libmaruku-ruby".'
		end
		if !found_calibre
			puts 'EPUB generation requires Calibre.'
			puts '  On Ubuntu call "sudo apt-get install calibre".'
		end
		
		if !found_calibre || !found_maruku then exit 1 end
	end
	
	directory TMP_DIR
	
	rule '.html' => '.mk' do |t|
		require 'maruku'
		
		mk_filename = t.source
		html_filename = t.name
		puts "Converting #{mk_filename} -> #{html_filename}"
		
		mk_file = File.open(mk_filename, 'r') do |mk|
			html_file = File.open(html_filename, 'w') do |html|
				code = Maruku.new(mk.read.encode("UTF-8")).to_html
				code.gsub!(/^(<h.) (id='[^']+?')/, '\1')
				html << code
				html << "\n"
			end
		end
	end
	
	src_for_converted = proc do |dst|
		base_name = dst.pathmap('%n')
		SOURCE_FILES.find { |s| s.pathmap('%n') == base_name }
	end
	
	rule '.mk' => src_for_converted do |t|
		src_filename = t.source
		dest_filename = t.name
		puts "Processing #{src_filename} -> #{dest_filename}"
		
		figures_dir = "../../../figures"
		
		dest_file = File.open(dest_filename, 'w')
		src_file = File.open(src_filename, 'r')
		until src_file.eof?
			line = src_file.readline
			
			matches = line.match /^\s*Insert\s(.*)/
			if matches
				image_path = matches[1]
				real_image_path = image_path.pathmap("#{figures_dir}/%X-tn%x")
				
				next_line = src_file.readline.chomp
				
				line = "![#{next_line}](#{real_image_path} \"#{next_line}\")\n"
			end
			
			dest_file << line
		end
		src_file.close
		dest_file.close
	end
	
	file INDEX_FILEPATH => TMP_DIR
	file INDEX_FILEPATH => HTML_FILES do
		index_file = File.open(INDEX_FILEPATH, 'w') do |file|
			file << '<?xml version="1.0" encoding="UTF-8"?>'
			file << "\n"
			file << '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" '
			file << '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
			file << "\n"
			file << "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='#{$lang}'>"
			file << '<head>'
			file << '<title>Pro Git - professional version control</title>'
			file << '</head>'
			file << '<body>'
			file << "\n"
			
			HTML_FILES.each do |chapter_file|
				file << File.open(chapter_file).read
				file << "\n"
			end
			
			file << '</body></html>'
			file << "\n"
		end
	end
	
	file TARGET_FILEPATH => INDEX_FILEPATH do
		opts = [
			'--language', $lang,
			'--authors', 'Scott Chacon',
			'--comments', 'Licensed under the Creative Commons Attribution-Non Commercial-Share Alike 3.0 license',
			
			'--cover', 'epub/title.png',
			'--extra-css', 'epub/ProGit.css',
			
			'--chapter', '//h:h1',
			'--level1-toc', '//h:h1',
			'--level2-toc', '//h:h2',
			'--level3-toc', '//h:h3',
		]
		
		sh $ebook_convert_cmd, INDEX_FILEPATH, TARGET_FILEPATH, *opts
	end
	
	CLEAN.push(*CONVERTED_MK_FILES)
	CLEAN.push(*HTML_FILES)
	CLEAN << INDEX_FILEPATH
	CLEAN << TMP_DIR
	CLOBBER << TARGET_FILEPATH
end

namespace :pdf do
        desc "generate a pdf"
        task :generate  do
                system("ruby makepdfs")
        end
end
