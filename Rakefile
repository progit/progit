# encoding: UTF-8

require 'rake/clean'
require 'redcarpet'

$lang = ENV['language']
$lang ||= 'en'

namespace :epub do
	TMP_DIR = File.join('epub', 'temp', $lang)
	INDEX_FILEPATH = File.join(TMP_DIR, 'progit.html')
	TARGET_FILEPATH = "progit-#{$lang}.epub"
	
	SOURCE_FILES = FileList.new(File.join($lang, '0*', '*.markdown')).sort
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
                system("bash makepdfs")
        end
end

class StderrDecorator
  def initialize(out)
    @out = out
  end

  def <<(x)
    @out << "#{x}"
    if x.match /REXML/
      raise ""
    end
  end
end

def test_lang(lang, out)
  error_code = false
  chapter_figure = {
    "01-introduction"       => 7,
    "02-git-basics"         => 2,
    "03-git-branching"      => 39,
    "04-git-server"         => 15,
    "05-distributed-git"    => 27,
    "06-git-tools"          => 1,
    "07-customizing-git"    => 3,
    "08-git-and-other-scms" => 0,
    "09-git-internals"      => 4}
  source_files = FileList.new(File.join(lang, '0*', '*.markdown')).sort
  source_files.each do |mk_filename|
    src_file = File.open(mk_filename, 'r')
    figure_count = 0
    until src_file.eof?
      line = src_file.readline
      matches = line.match /^#/
      if matches
        if line.match /^(#+).*#[[:blank:]]+$/
          out<< "\nBadly formatted title in #{mk_filename}: #{line}\n"
          error_code = true
        end
      end
      if line.match /^\s*Insert\s(.*)/i
	if line.match /^\s*Insert\s(.*)/
	  figure_count = figure_count + 1
	else
	  out << "\n#{lang}: Badly cased Insert directive: #{line}\n"
	  error_code = true
	end
      end
    end
    # This extraction is a bit contorted, because the pl translation renamed
    # the files, so the match is done on the directories.
    tab_fig_count = chapter_figure[File.basename(File.dirname(mk_filename))]
    expected_figure_count = tab_fig_count ? tab_fig_count:0
    if figure_count > expected_figure_count
      out << "\nToo many figures declared in #{mk_filename}\n"
      error_code = true
    end
  end
  begin
    mark = (source_files.map{|mk_filename| File.open(mk_filename, 'r'){
                |mk| mk.read.encode("UTF-8")}}).join("\n\n")
    require 'maruku'
    code = Maruku.new(mark, :on_error => :raise, :error_stream => StderrDecorator.new(out))
  rescue
    print $!
    error_code = true
  end
  error_code
end

$out = $stdout

namespace :ci do
  desc "Parallel Continuous integration"
  task :parallel_check do
    require 'parallel'
    langs = FileList.new('??')+FileList.new('??-??')
    results = Parallel.map(langs) do |lang|
      error_code = test_lang(lang, $out)
      if error_code
        print "processing #{lang} KO\n"
      else
        print "processing #{lang} OK\n"
      end
      error_code
    end
    fail "At least one language conversion failed" if results.any?
  end

  (FileList.new('??')+FileList.new('??-??')).each do |lang|
    desc "testing " + lang
    task (lang+"_check").to_sym do
      error_code = test_lang(lang, $out)
      fail "processing #{lang} KO\n" if error_code
      print "processing #{lang} OK\n"
      end
  end

  desc "Continuous Integration"   
  task :check do
    require 'maruku'
    langs = FileList.new('??')+FileList.new('??-??')
    if ENV['debug'] && $lang
      langs = [$lang]
    else
      excluded_langs = [
        ]
      excluded_langs.each do |lang|
        puts "excluding #{lang}: known to fail"
      end
      langs -= excluded_langs
    end
    errors = langs.map do |lang|
      print "processing #{lang} "
      error_code=test_lang(lang, $out)
      if error_code
        print "KO\n"
      else
        print "OK\n"
      end
      error_code
    end
    fail "At least one language conversion failed" if errors.any?
  end

end
