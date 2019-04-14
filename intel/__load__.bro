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
