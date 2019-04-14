Bro Intel Loader

First:

This script must know where the `intel/` directory is located. By default the `bro_intel_dir` variable in the script points to `/opt/bro/share/bro/site/intel/`. Change as needed to fit your directory structure. 

Description: 

This script will import single column lists of bro intel or a single entry from command line. Individual files must contain only one data type (ex. IP Addresses). `awk` can be helpful to parse a single column of entries from a source file. Example:
	
	#This command would parse the first column ($1) from source.txt
	#and output it to target.txt

	awk '{print $1}' source.txt > target.txt

Usage:

	#to enter a single item from command line
	bro_intel_import/bro_intel_import.sh

	#import.txt contains a single column of entries to import into bro intel
	bro_intel_import/bro_intel_import.sh import.txt

Intel Types:

	Type		Bro_Type		Intel_FileName
	IP Addresses	Intel::ADDR		addr.intel
	URLs		Intel::URL		url.intel
	Software Names	Intel::SOFTWARE		software.intel
	Domain Names	Intel::DOMAIN		domain.intel
	User Names	Intel::USER_NAME	user_name.intel
	File Hashes	Intel::FILE_HASH	file_hash.intel
	File Names	Intel::FILE_NAME	file_name.intel
	Cert Hashes	Intel::CERT_HASH	cert_hash.intel

Dependencies:

All `.intel` files must have the following header, with ONLY ONE TAB separating each field:

	#fields indicator       indicator_type  meta.source     meta.desc

The intel scripts must be loaded into bro. This is accomplished by the following commands (these are included in the `__load__.bro` files). The parent folder below must be added to the `local.bro` to be imported (ex. `/opt/bro/spool/installed-scripts-do-not-touch/site/local.bro`).
	
	----------__load__.bro (in parent folder)----------
	@load ./intel


	----------intel/__load__.bro-----------------------
	# Load intel scripts
	@load frameworks/intel/seen

	# Load intel data files
	redef Intel::read_files += {
        	fmt("%s/addr.intel", @DIR),
        	fmt("%s/domain.intel", @DIR),
        	fmt("%s/file_hash.intel", @DIR),
        	fmt("%s/file_name.intel", @DIR),
        	fmt("%s/software.intel", @DIR),
        	fmt("%s/url.intel", @DIR),
        	fmt("%s/user_name.intel", @DIR)
	};

Sources:

The following sites provide open-source intel that can be digested by this script:

        snort      -     http://labs.snort.org/feeds/ip-filter.blf
        et_ips     -     http://rules.emergingthreats.net/open/suricata/rules/compromised-ips.txt
        alienvault -     http://reputation.alienvault.com/reputation.generic
        malhosts   -     http://www.malwaredomainlist.com/hostslist/hosts.txt
        malips     -     http://www.malwaredomainlist.com/hostslist/ip.txt
        ciarmy     -     http://www.ciarmy.com/list/ci-badguys.txt
        mandiant   -     https://raw.github.com/jonschipp/mal-dnssearch/master/mandiant_apt1.dns

Expected Output:

If bro finds imported entries they will show up in an `intel.log` file with the restof bro's outputs. The info below is an example of what to expect in that log.

	#fields ts      uid     id.orig_h       id.orig_p       id.resp_h       id.resp_p       seen.indicator  seen.indicator_type     seen.where      seen.node       matched sources fuid    file_mime_type  file_desc
	#types  time    string  addr    port    addr    port    string  enum    enum    string  set[enum]       set[string]     string  string  string
	1555264884.881798       CB25Oe35ozNKb33g96      172.31.11.152   43942   107.152.104.110 80      107.152.104.110 Intel::ADDR     Conn::IN_RESP   bro     Intel::ADDR     CI Army,Alien Vault     -       -       -
	1555264900.394290       CT8HhF2g2q4ec5Tz2h      172.31.11.152   50134   172.31.0.2      53      ztl.firefoxupdata.com   Intel::DOMAIN   DNS::IN_REQUEST bro     Intel::DOMAIN   Mandiant        -       -       -

