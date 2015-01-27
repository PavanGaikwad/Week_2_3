require "fileutils"
class BrowserDriver


	@browsers = Hash.new

	@browsers[:chrome] = {
		:delete => ["C:\\Users\\Administrator\\AppData\\Local"],
		
		:versions => {
					"40" => {
							:executable => "C:\\Program Files (x86)\\Google\\Chrome\\Application\\40.0.2214.93\\chrome.exe"
							}
					}
		}

	@browsers[:iexplore] = {
		:delete => ["C:\\Users\\Administrator\\AppData\\Roaming\\Microsoft\\Windows\\Cookies",
					"C:\\Users\\Administrator\\AppData\\Local\\Microsoft\\Windows\\Temporary Internet Files",
					"C:\\Users\\Administrator\\AppData\\Local\\Microsoft\\Intern~1",
					"C:\\Users\\Administrator\\AppData\\Local\\Microsoft\\Windows\\Tempor~1",
					"C:\\Users\\Administrator\\AppData\\Roaming\\Microsoft\\Windows\\Cookies",
					"C:\\Users\\Administrator\\AppData\\Roaming\\Macromedia\\Flashp~1"],
		
		:versions => {
			"8.0.0" => {
				:executable => "iexplore.exe",
			},
			"9.0.0" => {
				:executable => "iexplore.exe",
			}
		}

		
	}

	@browsers[:firefox] = {
		:delete => ["C:\\Users\\Administrator\\AppData\\Local\\Mozilla\\Firefox"],

		:versions => {
			"35.0" => {
			:executable => "C:\\Program Files (x86)\\firefox 35.0\\firefox.exe"
			}
		}
	}


	
	def launch(browser_name, browser_version, url_to_launch="http://google.com" ,proxy_url=nil)
		browser_name = browser_name.to_sym
		browser_version = browser_version.to_sym

		configure_proxy(proxy_url) if proxy_url
		if @browsers.include?(browser_name)
		  @browser_object = @browsers[browser_name]

		  if @browser_object.include?(browser_version)
		  	system("START #{@browser_object[browser_version][:executable]}")
		  else
		    "browser version not supported"	
		  	
		else
		  "browser not supported"	
	end

	def stop(browser_name, browser_version)
		browser_name = browser_name.to_sym
		browser_version = browser_version.to_sym

		if @browsers.include?(browser_name)
		  executable = File.basename( @browsers[browser_name][browser_version][:executable] )
		  system("taskkill /F /IM #{executable} /T")
		else
	end

	def cleanup(browser_name)
		browser_name = browser_name.to_sym

		dirs_to_delete = @browsers[browser_name][:delete]

		dirs_to_delete.each do |dir|
			delete(dir)
		end
	end

	def delete(dir)
		FileUtils.remove_dir(dir)
	end

	def delete_browser_history
		require "win32/registry"

		#set clear at exit to false
		privacy_key = "Software\\Microsoft\\Internet Explorer\\Privacy"
		Win32::Registry::HKEY_CURRENT_USER.open(privacy_key, Win32::Registry::KEY_WRITE) do |reg|
			reg["DontClear", Win32::Registry::REG_DWORD] = 00000001
		end

		# delete all TypedURLs except the default one.
		history_key = "Software\\Microsoft\\Internet Explorer\\TypedURLs"
		# history_key = "Software\\Microsoft\\Windows\CurrentVersion\\Internet Settings\\Url"
		Win32::Registry::HKEY_CURRENT_USER.open(key, Win32::Registry::KEY_WRITE) do |reg|
			reg.each { |key, value| reg.delete_key(key) if key != "Default" }
		end
	end

	def configure_proxy(proxy_url)
		require "win32/registry"
		key = "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings"
		Win32::Registry::HKEY_CURRENT_USER.open(key, Win32::Registry::KEY_WRITE) do |reg|
			reg["ProxyEnable", Win32::Registry::REG_DWORD] = 00000001
			reg["ProxyServer"] = proxy_url
		end
	end

	def reset_proxy()
		require "win32/registry"
		key = "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings"
		Win32::Registry::HKEY_CURRENT_USER.open(key, Win32::Registry::KEY_WRITE) do |reg|
			reg["ProxyEnable", Win32::Registry::REG_DWORD] = 00000000
			reg["ProxyServer"] = ""
		end
	end
end