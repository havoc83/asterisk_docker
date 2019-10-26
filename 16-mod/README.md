## Modified version of Asterisk 16
This version of Asterisk 16 contains two modified apps.  
#### app_queue
App_queue has been modified so that max hold time for all calls within queue can be tracked.  This will return an extra variable on ami calls named MaxHold that will show the maximum time a caller has waited in queue.  
#### app_record
App_record has been modified so that instead of returning "DTMF" when agi calls to Record terminate it will push the actual dtmf digit that was received.  This change has not yet been tested.