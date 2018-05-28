//
//  _Dropbox.h


/**
 
 
Dropbox Sync API Needed frameworks & libs :

1 Dropbox.framework  			# https://dl.dropboxusercontent.com/s/bq1764wzfhlfeqt/dropbox-ios-sync-sdk-2.0.2.zip

2 libc++.dylib					# system, ios sdk

3 libsqlite.dylib  				# system, ios sdk

4 SystemConfiguration.framework 	# system, ios sdk

5 CFNetwork.framework 				# system, ios sdk

6 Security.framework 				# system, ios sdk








Dropbox Core API Needed frameworks & libs :

 
 
 
**/



// Choose one of below API



/** Sync API **/
#import <Dropbox/Dropbox.h>

#import "DropboxSyncAPIManager.h"

#import "DropboxSyncUploader.h"


/** Core API **/
// #import "DropboxCoreAPIManager.h"