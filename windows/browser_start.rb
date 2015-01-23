require "fileutils"
class BrowserDriver


	@browsers = Hash.new

	@browsers[:chrome] = {
		:delete => ["C:\\Users\\Administrator\\AppData\\Local"],
		:executable => "chrome.exe",
		:versions => {
					"23.0.0" => {
							:location => "C:\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\User Data"
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
		:executable => "iexplore.exe",
		:versions => {
			"8.0.0" => {
				:location => "iexplore"
			}
		}
	}

	@browsers[:firefox] = {
		:delete => ["C:\\Users\\Administrator\\AppData\\Local\\Mozilla\\Firefox\\Profiles",
					"C:\\Users\\Administrator\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles"]
	}


	

	def launch(browser_name, browser_version, url_to_launch="http://google.com" ,proxy_url=nil)
		configure_proxy(proxy_url) if proxy_url
		case browser_name
		when "chrome" then system("START #{@browsers[browser_name.to_sym][browser_name][:location]}\\#{browser_version}\\@browsers[browser_name.to_sym][browser_name][:executable] #{url_to_launch}")
		when "iexplore" then system("START ")
		else puts "browser not supported"
	end

	def stop(browser_name)
		executable = @browsers[browser_name.to_sym][:executable]
		system("taskkill /F /IM #{executable} /T")
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

		cookies_key = ""

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