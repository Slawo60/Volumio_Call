# Volumio_Call
Bash script that pause volumio when a call is coming and play when the call is ended

I use it with Asterisk so that a specific phone can pause the music when a call is received or emit.
The script store the status of the player so it dosen't play when the last state was pause.

### Prerequisites

The shell script need curl and jq to work

```
apt-get install curl
apt-get install jq
```

### Installing

Put the script in your favorite linux machine and chmod the scipt.

```
chmod +x ./volumino_shutuponesec.sh
```

## Using the script standalone

Store player state and pause the player if the player was playing:

```
./volumino_shutuponesec.sh -s
```

To recover player state:

```
./volumino_shutuponesec.sh -r
```

### Installing for asterisk

Put the script in "/etc/asterisk"
And make it owned by asterisk user and executable

```
chown asterisk /etc/asterisk/volumino_shutuponesec.sh
chmod +x /etc/asterisk/volumino_shutuponesec.sh
```
## Using the script with asterisk

In extenstion.conf, I sugest to create a context for the secific phone so that every call begin with

```
exten => _601,1,System(/etc/asterisk/volumino_shutuponesec.sh -s)
```
And finish with 
```
exten => h, 1, System(/etc/asterisk/volumino_shutuponesec.sh -r)
```
The extension h is handeling hangup code (end of call or no answer), more here (https://wiki.asterisk.org/wiki/display/AST/Special+Dialplan+Extensions).

