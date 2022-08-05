Include %IKPublic

Class Community.iKnow.Utils
{

/// Points to a file with blacklist
Parameter BLFileLocation As STRING = "blacklist.txt";

/// Points to a file with Sets
Parameter SetsFileLocation As STRING = "sets.txt";

Parameter PostDomainName As STRING = "CommunityPost";

Parameter AnswerDomainName As STRING = "CommunityAnswer";

Parameter BlackLists As STRING = "BLcommunity";

/// To install, run the command "do ##class(Community.iKnow.Utils).setup()"
ClassMethod setup() As %Status
{
	
	do ##class(Community.iKnow.Post).Update()
	//do ##class(Community.iKnow.Answer).Update()
	do ..AddSetsFromFile()
	do ..CreateBlackLists(..#PostDomainName)
	//do ..CreateBlackLists(..#AnswerDomainName)
	return $$$OK
}

/// To update the domain and blacklists
ClassMethod update() As %Status
{
	do ..AddSetsFromFile()
	do ..UpdateBlackLists(..#PostDomainName)
	do ##class(Community.iKnow.Post).Update()
	do ##class(Community.iKnow.Similar).Start()
	return $$$OK
}

/// To delete, run the command "do ##class(Community.iKnow.Utils).remove()"
ClassMethod remove() As %Status
{
	k ^CommunityiKnowSets
	do ..DeleteBlackLists(..#PostDomainName)
	//do ..DeleteBlackLists(..#AnswerDomainName)
	do ..DeleteDomain(..#PostDomainName)
	//do ..DeleteDomain(..#AnswerDomainName)
	return $$$OK
}

/// Delete a domain with all data
/// domName - domain name
ClassMethod DeleteDomain(domName As %String) As %Status
{
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domain  = ##class(%iKnow.Domain).Open(domName)
		set domainId = domain.Id
		set tSC = ##class(%iKnow.Domain).DeleteId(domainId)	
		
		if (tSC = $$$OK) {
			write "Domain ", domName, " deleted successfully.", !
			return $$$OK
		}
		else {
			write "Error: failed to delete domain ", domName, !
			return $$$ERROR()
		}
	}
	else {
		write "Domain ", domName, " doesn't exist", !
		return $$$ERROR()
	}
}

ClassMethod CreateDomainIfNotExists(domName As %String) As %Status
{
	if '(##class(%iKnow.Domain).Exists(domName)) 
	{
		write "Domain " _ domName _ " does not exist.", !
	
		write "Creating new domain: " _ domName, !
				
		#dim status As %Status = ..CreateDomain(domName)
			
		if (status = $$$OK) 
		{
			write "New domain " _ domName _ " was created successfully.", !	
		}
		else 
		{
			return status
		}	
	}
	return 0
}

/// Create a new domain
/// domName - domain name
ClassMethod CreateDomain(domName As %String) As %iKnow.Domain
{
	if (##class(%iKnow.Domain).Exists(domName))
	{
		#dim domain As %iKnow.Domain = ##class(%iKnow.Domain).Open(domName)
		write "   open domain ", domName, " ", !
	}
	else
	{
		set domain = ##class(%iKnow.Domain).%New(domName)
		do domain.%Save()
		do domain.SetParameter($$$IKPSTEMMING, 1)	
		do domain.%Save()
		
		write "   domain ", domName, " created!", !
	}
	return domain
}

/// This method create blacklist on the file BLs.txt, 
/// contains the listed terms, "!" - the comment character at the beginning of the line
/// domName - domain name
/// BLName - blacklist name
ClassMethod CreateBlackLists(domName As %String, BLName As %String = {..#BlackLists}) As %Integer
{
 
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	set blackListId = ##class(%iKnow.Utils.MaintenanceAPI).CreateBlackList(domainId, BLName)
	
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc = stream.LinkToFile(..#BLFileLocation)
	
	while 'stream.AtEnd {		
		set line = stream.ReadLine()	
		set sc = ##class(%iKnow.Utils.MaintenanceAPI).AddStringToBlackList(domainId, blackListId, line)
		write "   line: ",line," added to black list",!
	}

	return blackListId
}

ClassMethod AddSetsFromFile(FileName As %String = {..#SetsFileLocation}) As %Status
{
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc = stream.LinkToFile(FileName)
	
	while 'stream.AtEnd {		
		set line = stream.ReadLine()		
		set ^CommunityiKnowSets($p(line,",",1)) = $p(line,",",2)
		write "   line: ",line," added",!
	}
}

/// This method delete blacklist
/// domName - domain name
/// BLName - blacklist name
ClassMethod DeleteBlackLists(domName As %String, BLName As %String = {..#BlackLists}) As %Status
{
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	set blackListId = ##class(%iKnow.Utils.MaintenanceAPI).GetBlackListId(domainId, BLName)
	set sc = ##class(%iKnow.Utils.MaintenanceAPI).DropBlackList(domainId, blackListId)
	
	if (sc=$$$OK)
	{	
		write "   black list deleted",!}
	else 
	{
		write "Error deleting black list",!
		write sc,!
	}
	
	return $$$OK
}

/// This method update and create blacklists on the file BlackList.txt, 
/// contains the listed terms, "!" - the comment character at the beginning of the line
/// domName - domain name
/// BLName - blacklist name
ClassMethod UpdateBlackLists(domName As %String, BLName As %String = {..#BlackLists}) As %Status
{
	
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	set sc = ..DeleteBlackLists(domName, BLName)
	if (sc = $$$OK)
	{
		write "BlackList ",BLName, " deleted",!	
	}
	
	set sc = ..CreateBlackLists(domName, BLName)
	if (sc = $$$OK)
	{
		write "BlackList ",BLName, " created",!	
	}	

	return $$$OK
}

/// Method for adding Set
ClassMethod AddSet(Concept As %String, Set As %String) As %Status
{
	set ^CommunityiKnowSets(Concept) = Set
	return $$$OK
}

ClassMethod SimPieceCount(str1, str2) As %Integer [ SqlProc ]
{
	set count = 0
	for i=1:1:$l(str1,",")
	{
		set piece = $p(str1,",",i)
		if ($f(str2,piece) > 0){
			set count = count + 1
		}
	}
	return count
}

}

