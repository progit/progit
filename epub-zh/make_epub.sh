#!/usr/bin/env groovy

//script requires Groovy, Markdown and Calibre. On Ubuntu call "sudo apt-get install groovy markdown calibre"

@GrabResolver(name='scala-tools', root='http://scala-tools.org/repo-releases')
@Grab(group='org.markdownj', module='markdownj', version='0.3.0-1.0.2b4')

import com.petebevin.markdown.MarkdownProcessor

println "This script requires Groovy, Markdown and Calibre. On Ubuntu call 'sudo apt-get install groovy calibre'"

def lang = 'zh'
def langDir = new File("..", lang)
def dest = new File("target")

dest.deleteDir()
dest.mkdirs()

def markdownFile = ~/.*\.markdown/
def filesForIndex = []
def mp = new MarkdownProcessor()

langDir.eachDir { dir -> 
	dir.eachFileMatch(markdownFile) { file ->
		println "Processing ${file}"

		def fileContent = file.getText('UTF-8')
		
		//def content = fileContent.replaceAll(/(?m)^Insert\s+(.*)(\.png)\s+(Figure\s+.*)/, '[$3](../../figures/$1-tn$2 "$3")')
		def content = fileContent.replaceAll(/(?m)^Insert\s+(.*)(\.png)\s+(.*?\s+.*)/, '![$3](../../figures/$1-tn$2 "$3")')

		def htmlFile = new File(dest, file.name + ".html")
    	filesForIndex += htmlFile;

		def result = mp.markdown(content)

		htmlFile.withWriter('UTF-8') {
			it << result
		}
  } //file
} //dir 


// concat all files into one single html file
def indexFile = new File(dest, "progit.html")
def subtitle = new File("subtitle")
indexFile.withWriter('UTF-8') { writer -> 
	writer << """<html xmlns="http://www.w3.org/1999/xhtml"><head><title>Pro Git - """
    writer << subtitle.getText('UTF-8')
	writer << """</title></head><body>"""

	filesForIndex.sort().each { file ->
		writer << file.getText('UTF-8')
	}

	writer << """</body></html>"""
}

def epubFile = new File(dest, "progit-${lang}.epub")
println "EpubFile" + epubFile

def cmd = ["""/Applications/calibre.app/Contents/MacOS/ebook-convert""", indexFile.getPath(), epubFile.getPath(), 
  """--cover""", """cover.png""", 
  """--authors""", "Scott Chacon", 
  "--comments", "licensed under the Creative Commons Attribution-Non Commercial-Share Alike 3.0 license", 
  "--level1-toc", "//h:h1", 
  "--level2-toc", "//h:h2", 
  "--level3-toc", "//h:h3",
  "--extra-css", "ProGit.css",
  "--language", lang
]

def proc = cmd.execute();
proc.waitFor();
