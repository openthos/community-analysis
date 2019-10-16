- location/java/android/location/LocationManager.java
```
 433     public String getBestProvider(Criteria criteria, boolean enabledOnly) {                                                                                                                            
 434         checkCriteria(criteria);
 435         try {
 436             return mService.getBestProvider(criteria, enabledOnly);
 437         } catch (RemoteException e) {
 438             throw e.rethrowFromSystemServer();
 439         }
 440     }
```

```
 345     public List<String> getAllProviders() {                                                                                                                                                            
 346         try {
 347             return mService.getAllProviders();
 348         } catch (RemoteException e) {
 349             throw e.rethrowFromSystemServer();
 350         }
 351     }
```

```
 360     public List<String> getProviders(boolean enabledOnly) {
 361         try {
 362             return mService.getProviders(null, enabledOnly);
 363         } catch (RemoteException e) {
 364             throw e.rethrowFromSystemServer();
 365         }
 366     }

```

```
 379     public LocationProvider getProvider(String name) {                                                                                                                                                 
 380         checkProvider(name);
 381         try {
 382             ProviderProperties properties = mService.getProviderProperties(name);
 383             if (properties == null) {
 384                 return null;
 385             }
 386             return createProvider(name, properties);
 387         } catch (RemoteException e) {
 388             throw e.rethrowFromSystemServer();
 389         }
 390     }


```
