```
Please note that this is only a sample of the code.
```

# mountdrives
A replacement for Group Policy to mount drives based on memberships. This script will request the logged in user's memberships from Active Directory, and parse them to see if there's a match in the mountpoints folder.

## Installation
This script should be deployed to be run on user login as the currently logged in user. This can be done through group policy, task scheduler, or other means.

## File Structure
Each file is tab delimited. The first entry is the drive letter, then a tab, and then the path to the server. Optionally a third parameter can be added to give the mount a custom name.

```
F	\\foo\bar	FooBar
```

## Exceptions
Sometimes it's necessary to add mounts that aren't defined by group membership. This can be done in the exception folder. The two subfolders specify if it's per user or per computer.
Computer exceptions should be named per hostname, and user exceptions should be named the username. The file should have the same structure as above.
