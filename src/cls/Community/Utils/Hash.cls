Class Community.Utils.Hash [ Abstract ]
{

/// Returns MD5 hash is Base64,
/// Argument count should be less than 255, 
/// and their total length sould not exceed 3 641 144 symbols
ClassMethod Hash(Arg...) As %Binary
{
	Set Delimiter = $c(255)
	Set String = Delimiter
	For i=1:1:Arg {
		Set String = String _ Arg(i) _ Delimiter
	}
	return $System.Encryption.Base64Encode($system.Encryption.MD5Hash(String))
}

}

