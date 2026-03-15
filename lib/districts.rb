# frozen_string_literals: true

DISTRICTS = {

  'bioraznoobrazie-ekaterinburga' => {                     
    neighbors: {
      projects: [
        'bioraznoobrazie-polevskogo',                      
        'bioraznoobrazie-verhney-pyshmy-i-sredneuralska',  
        'bioraznoobrazie-revdy-i-degtyarska',              
        'bioraznoobrazie-beryozovskogo',                   
        'bioraznoobrazie-beloyarskogo-rayona',             
        'bioraznoobrazie-pervouralska',                    
        'bioraznoobrazie-sysertskogo-rayona',              
      ],
      places: [],
    },
  },

  'bioraznoobrazie-sysertskogo-rayona' => {                         
    neighbors: {
      projects: [
        'bioraznoobrazie-polevskogo',                               
        'bioraznoobrazie-beloyarskogo-rayona',                      
        'bioraznoobrazie-kamenska-uralskogo-i-kamenskogo-rayona',   
        'bioraznoobrazie-ekaterinburga',                            
      ],
      places: [
        164059,
        'kaslinskiy-mun-rayon-2020',
        'snezhinsk-gor-okrug-2020',
      ],
    },
  },

  'bioraznoobrazie-nizhnego-tagila' => {                 
    neighbors: {
      projects: [
        'bioraznoobrazie-kushvy-i-verhney-tury',         
        'bioraznoobrazie-kirovgrada-i-verhnego-tagila',  
        'bioraznoobrazie-prigorodnogo-rayona',           
        'bioraznoobrazie-shalinskogo-rayona',            
        'bioraznoobrazie-pervouralska',                  
      ],
      places: [
        'gornozavodskiy-rayon',
        'lys-venskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-kamenska-uralskogo-i-kamenskogo-rayona' => {  
    neighbors: {
      projects: [
        'bioraznoobrazie-bogdanovichskogo-rayona',               
        'bioraznoobrazie-beloyarskogo-rayona',                   
        'bioraznoobrazie-sysertskogo-rayona',                    
      ],
      places: [
        'kaslinskiy-mun-rayon-2020',
        'katayskiy-rayon',
        'kunashak-mun-rayon-2020',
      ],
    },
  },

  'bioraznoobrazie-karpinska-i-volchanska' => {   
    neighbors: {
      projects: [
        'bioraznoobrazie-serova',                 
        'bioraznoobrazie-novolyalinskogo-rayona', 
        'bioraznoobrazie-krasnoturinska',         
        'bioraznoobrazie-severouralska',          
      ],
      places: [
        'aleksandrovsk-gorsovet',
        'gornozavodskiy-rayon',
        'kizel-gorsovet',
        'krasnovisherskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-pervouralska' => {                        
    neighbors: {
      projects: [
        'bioraznoobrazie-kirovgrada-i-verhnego-tagila',      
        'bioraznoobrazie-nizhneserginskogo-rayona',          
        'bioraznoobrazie-verhney-pyshmy-i-sredneuralska',    
        'bioraznoobrazie-shalinskogo-rayona',                
        'bioraznoobrazie-revdy-i-degtyarska',                
        'bioraznoobrazie-nevyanskogo-rayona-i-novouralska',  
        'bioraznoobrazie-nizhnego-tagila',                   
        'bioraznoobrazie-ekaterinburga',                     
      ],
      places: [],
    },
  },

  'bioraznoobrazie-severouralska' => {             
    neighbors: {
      projects: [
        'bioraznoobrazie-serova',                  
        'bioraznoobrazie-ivdelya-i-pelyma',        
        'bioraznoobrazie-karpinska-i-volchanska',  
      ],
      places: [
        'krasnovisherskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-beloyarskogo-rayona' => {                        
    neighbors: {
      projects: [
        'bioraznoobrazie-asbesta',                                  
        'bioraznoobrazie-suholozhskogo-rayona',                     
        'bioraznoobrazie-bogdanovichskogo-rayona',                  
        'bioraznoobrazie-zarechnogo',                               
        'bioraznoobrazie-beryozovskogo',                            
        'bioraznoobrazie-kamenska-uralskogo-i-kamenskogo-rayona',   
        'bioraznoobrazie-sysertskogo-rayona',                       
        'bioraznoobrazie-ekaterinburga',                            
      ],
      places: [],
    },
  },

  'bioraznoobrazie-beryozovskogo' => {                    
    neighbors: {
      projects: [
        'bioraznoobrazie-asbesta',                        
        'bioraznoobrazie-rezhevskogo-rayona',             
        'bioraznoobrazie-zarechnogo',                     
        'bioraznoobrazie-verhney-pyshmy-i-sredneuralska', 
        'bioraznoobrazie-beloyarskogo-rayona',            
        'bioraznoobrazie-ekaterinburga',                  
      ],
      places: [],
    },
  },

  'bioraznoobrazie-nevyanskogo-rayona-i-novouralska' => {  
    neighbors: {
      projects: [
        'bioraznoobrazie-kirovgrada-i-verhnego-tagila',    
        'bioraznoobrazie-rezhevskogo-rayona',              
        'bioraznoobrazie-prigorodnogo-rayona',             
        'bioraznoobrazie-verhney-pyshmy-i-sredneuralska',  
        'bioraznoobrazie-pervouralska',                    
      ],
      places: [],
    },
  },

  'bioraznoobrazie-revdy-i-degtyarska' => {            
    neighbors: {
      projects: [
        'bioraznoobrazie-polevskogo',                  
        'bioraznoobrazie-nizhneserginskogo-rayona',    
        'bioraznoobrazie-pervouralska',                
        'bioraznoobrazie-ekaterinburga',               
      ],
      places: [
        'nyazepetrovskiy-mun-rayon-2020',
      ],
    },
  },

  'bioraznoobrazie-artinskogo-rayona' => {                          
    neighbors: {
      projects: [
        'bioraznoobrazie-achitskogo-rayona',                        
        'bioraznoobrazie-nizhneserginskogo-rayona',                 
        'bioraznoobrazie-krasnoufimska-i-krasnoufimskogo-rayona',   
      ],
      places: [
        'belokatayskiy-rayon',
        'mechetlinskiy-rayon',
        'nyazepetrovskiy-mun-rayon-2020',
      ],
    },
  },

  'bioraznoobrazie-shalinskogo-rayona' => {            
    neighbors: {
      projects: [
        'bioraznoobrazie-achitskogo-rayona',           
        'bioraznoobrazie-nizhneserginskogo-rayona',    
        'bioraznoobrazie-pervouralska',                
        'bioraznoobrazie-nizhnego-tagila',             
      ],
      places: [
        'berezovskiy-rayon-perm-ru',
        'kishertskiy-rayon',
        'lys-venskiy-rayon',
        'suksunskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-krasnoufimska-i-krasnoufimskogo-rayona' => {  
    neighbors: {
      projects: [
        'bioraznoobrazie-achitskogo-rayona',                     
        'bioraznoobrazie-artinskogo-rayona',                     
      ],
      places: [
        'askinskiy-rayon',
        'duvanskiy-rayon',
        'mechetlinskiy-rayon',
        'oktyabr-skiy-perm-ru',
        'suksunskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-verhney-pyshmy-i-sredneuralska' => {       
    neighbors: {
      projects: [
        'bioraznoobrazie-rezhevskogo-rayona',                 
        'bioraznoobrazie-nevyanskogo-rayona-i-novouralska',   
        'bioraznoobrazie-beryozovskogo',                      
        'bioraznoobrazie-pervouralska',                       
        'bioraznoobrazie-ekaterinburga',                      
      ],
      places: [],
    },
  },

  'bioraznoobrazie-nizhneserginskogo-rayona' => { 
    neighbors: {
      projects: [
        'bioraznoobrazie-achitskogo-rayona',      
        'bioraznoobrazie-shalinskogo-rayona',     
        'bioraznoobrazie-artinskogo-rayona',      
        'bioraznoobrazie-revdy-i-degtyarska',     
        'bioraznoobrazie-pervouralska',           
      ],
      places: [
        'nyazepetrovskiy-mun-rayon-2020',
      ],
    },
  },

  'bioraznoobrazie-artyomovskogo-rayona' => {               
    neighbors: {
      projects: [
        'bioraznoobrazie-irbita-i-irbitskogo-rayona',       
        'bioraznoobrazie-asbesta',                          
        'bioraznoobrazie-suholozhskogo-rayona',             
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona', 
        'bioraznoobrazie-rezhevskogo-rayona',               
      ],
      places: [],
    },
  },

  'bioraznoobrazie-polevskogo' => {            
    neighbors: {
      projects: [
        'bioraznoobrazie-revdy-i-degtyarska',  
        'bioraznoobrazie-sysertskogo-rayona',  
        'bioraznoobrazie-ekaterinburga',       
      ],
      places: [
        164059,
        'nyazepetrovskiy-mun-rayon-2020',
      ],
    },
  },

  'bioraznoobrazie-prigorodnogo-rayona' => {                  
    neighbors: {
      projects: [
        'bioraznoobrazie-krasnouralska',                      
        'bioraznoobrazie-kushvy-i-verhney-tury',              
        'bioraznoobrazie-verhnesaldinskogo-rayona',           
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',   
        'bioraznoobrazie-kirovgrada-i-verhnego-tagila',       
        'bioraznoobrazie-rezhevskogo-rayona',                 
        'bioraznoobrazie-nevyanskogo-rayona-i-novouralska',   
        'bioraznoobrazie-nizhnego-tagila',                    
      ],
      places: [],
    },
  },

  'bioraznoobrazie-nizhney-tury-i-lesnogo' => {     
    neighbors: {
      projects: [
        'bioraznoobrazie-krasnouralska',            
        'bioraznoobrazie-verhoturskogo-rayona',     
        'bioraznoobrazie-kushvy-i-verhney-tury',    
        'bioraznoobrazie-novolyalinskogo-rayona',   
        'bioraznoobrazie-kachkanara',               
      ],
      places: [
        'gornozavodskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-zarechnogo' => {             
    neighbors: {
      projects: [
        'bioraznoobrazie-beryozovskogo',        
        'bioraznoobrazie-beloyarskogo-rayona',  
      ],
      places: [],
    },
  },

  'bioraznoobrazie-rezhevskogo-rayona' => {                  
    neighbors: {
      projects: [
        'bioraznoobrazie-asbesta',                           
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',  
        'bioraznoobrazie-prigorodnogo-rayona',               
        'bioraznoobrazie-artyomovskogo-rayona',              
        'bioraznoobrazie-verhney-pyshmy-i-sredneuralska',    
        'bioraznoobrazie-nevyanskogo-rayona-i-novouralska',  
        'bioraznoobrazie-beryozovskogo',                     
      ],
      places: [],
    },
  },

  'bioraznoobrazie-kirovgrada-i-verhnego-tagila' => {       
    neighbors: {
      projects: [
        'bioraznoobrazie-prigorodnogo-rayona',              
        'bioraznoobrazie-nevyanskogo-rayona-i-novouralska', 
        'bioraznoobrazie-pervouralska',                     
        'bioraznoobrazie-nizhnego-tagila',                  
      ],
      places: [],
    },
  },

  'bioraznoobrazie-krasnoturinska' => {            
    neighbors: {
      projects: [
        'bioraznoobrazie-serova',                  
        'bioraznoobrazie-novolyalinskogo-rayona',  
        'bioraznoobrazie-severouralska',           
      ],
      places: [],
    },
  },

  'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona' => {           
    neighbors: {
      projects: [
        'bioraznoobrazie-serovskogo-rayona-sosva',                  
        'bioraznoobrazie-garinskogo-rayona',                        
        'bioraznoobrazie-taborinskogo-rayona',                      
        'bioraznoobrazie-nizhney-saldy',                            
        'bioraznoobrazie-verhoturskogo-rayona',                     
        'bioraznoobrazie-turinskogo-rayona',                        
        'bioraznoobrazie-irbita-i-irbitskogo-rayona',               
        'bioraznoobrazie-verhnesaldinskogo-rayona',                 
        'bioraznoobrazie-rezhevskogo-rayona',                       
        'bioraznoobrazie-prigorodnogo-rayona',                      
        'bioraznoobrazie-artyomovskogo-rayona',                     
      ],
      places: [],
    },
  },

  'bioraznoobrazie-bogdanovichskogo-rayona' => {                  
    neighbors: {
      projects: [
        'bioraznoobrazie-kamyshlova-i-kamyshlovskogo-rayona',     
        'bioraznoobrazie-asbesta',                                
        'bioraznoobrazie-suholozhskogo-rayona',                   
        'bioraznoobrazie-beloyarskogo-rayona',                    
        'bioraznoobrazie-kamenska-uralskogo-i-kamenskogo-rayona', 
      ],
      places: [
        'katayskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-tugulymskogo-rayona' => {         
    neighbors: {
      projects: [
        'bioraznoobrazie-baykalovskogo-rayona',      
        'bioraznoobrazie-talitskogo-rayona',         
        'bioraznoobrazie-slobodo-turinskogo-rayona', 
      ],
      places: [
        'isetskiy-rayon-ru',
        'tyumenskiy-rayon-2023',
        'shatrovskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-ivdelya-i-pelyma' => {      
    neighbors: {
      projects: [
        'bioraznoobrazie-garinskogo-rayona',   
        'bioraznoobrazie-serova',              
        'bioraznoobrazie-severouralska',       
      ],
      places: [
        'berezovskiy-rayon',
        'kondinskiy-rayon',
        'krasnovisherskiy-rayon',
        'sovetskiy-rayon-khanty-mansiy-ru',
        'troitsko-pechorskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-verhnesaldinskogo-rayona' => {             
    neighbors: {
      projects: [
        'bioraznoobrazie-krasnouralska',                      
        'bioraznoobrazie-nizhney-saldy',                      
        'bioraznoobrazie-verhoturskogo-rayona',               
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',   
        'bioraznoobrazie-prigorodnogo-rayona',                
      ],
      places: [],
    },
  },

  'bioraznoobrazie-suholozhskogo-rayona' => {                 
    neighbors: {
      projects: [
        'bioraznoobrazie-kamyshlova-i-kamyshlovskogo-rayona', 
        'bioraznoobrazie-irbita-i-irbitskogo-rayona',         
        'bioraznoobrazie-asbesta',                            
        'bioraznoobrazie-bogdanovichskogo-rayona',            
        'bioraznoobrazie-artyomovskogo-rayona',               
        'bioraznoobrazie-beloyarskogo-rayona',                
      ],
      places: [],
    },
  },

  'bioraznoobrazie-slobodo-turinskogo-rayona' => {  
    neighbors: {
      projects: [
        'bioraznoobrazie-baykalovskogo-rayona',     
        'bioraznoobrazie-turinskogo-rayona',        
        'bioraznoobrazie-tavdinskogo-rayona',       
        'bioraznoobrazie-tugulymskogo-rayona',      
      ],
      places: [
        'nizhnetavdinskiy-rayon-2023',
        'tyumenskiy-rayon-2023',
      ],
    },
  },

  'bioraznoobrazie-talitskogo-rayona' => {            
    neighbors: {
      projects: [
        'bioraznoobrazie-baykalovskogo-rayona',       
        'bioraznoobrazie-irbita-i-irbitskogo-rayona', 
        'bioraznoobrazie-pyshminskogo-rayona',        
        'bioraznoobrazie-tugulymskogo-rayona',        
      ],
      places: [
        'dalmatovskiy-rayon',
        'shadrinskiy-rayon',
        'shatrovskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-kachkanara' => {               
    neighbors: {
      projects: [
        'bioraznoobrazie-kushvy-i-verhney-tury',  
        'bioraznoobrazie-nizhney-tury-i-lesnogo', 
      ],
      places: [
        'gornozavodskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-pyshminskogo-rayona' => {                   
    neighbors: {
      projects: [
        'bioraznoobrazie-kamyshlova-i-kamyshlovskogo-rayona',  
        'bioraznoobrazie-irbita-i-irbitskogo-rayona',          
        'bioraznoobrazie-talitskogo-rayona',                   
      ],
      places: [
        'dalmatovskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-tavdinskogo-rayona' => {            
    neighbors: {
      projects: [
        'bioraznoobrazie-taborinskogo-rayona',         
        'bioraznoobrazie-turinskogo-rayona',           
        'bioraznoobrazie-slobodo-turinskogo-rayona',   
      ],
      places: [
        'kondinskiy-rayon',
        'nizhnetavdinskiy-rayon-2023',
        'tobolskiy-rayon-2023',
      ],
    },
  },

  'bioraznoobrazie-asbesta' => {                    
    neighbors: {
      projects: [
        'bioraznoobrazie-suholozhskogo-rayona',     
        'bioraznoobrazie-bogdanovichskogo-rayona',  
        'bioraznoobrazie-rezhevskogo-rayona',       
        'bioraznoobrazie-artyomovskogo-rayona',     
        'bioraznoobrazie-beryozovskogo',            
        'bioraznoobrazie-beloyarskogo-rayona',      
      ],
      places: [],
    },
  },

  'bioraznoobrazie-irbita-i-irbitskogo-rayona' => {            
    neighbors: {
      projects: [
        'bioraznoobrazie-baykalovskogo-rayona',                
        'bioraznoobrazie-kamyshlova-i-kamyshlovskogo-rayona',  
        'bioraznoobrazie-turinskogo-rayona',                   
        'bioraznoobrazie-pyshminskogo-rayona',                 
        'bioraznoobrazie-talitskogo-rayona',                   
        'bioraznoobrazie-suholozhskogo-rayona',                
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',    
        'bioraznoobrazie-artyomovskogo-rayona',                
      ],
      places: [],
    },
  },

  'bioraznoobrazie-turinskogo-rayona' => {                   
    neighbors: {
      projects: [
        'bioraznoobrazie-baykalovskogo-rayona',              
        'bioraznoobrazie-taborinskogo-rayona',               
        'bioraznoobrazie-irbita-i-irbitskogo-rayona',        
        'bioraznoobrazie-tavdinskogo-rayona',                
        'bioraznoobrazie-slobodo-turinskogo-rayona',         
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',  
      ],
      places: [],
    },
  },

  'bioraznoobrazie-achitskogo-rayona' => {                        
    neighbors: {
      projects: [
        'bioraznoobrazie-nizhneserginskogo-rayona',               
        'bioraznoobrazie-krasnoufimska-i-krasnoufimskogo-rayona', 
        'bioraznoobrazie-shalinskogo-rayona',                     
        'bioraznoobrazie-artinskogo-rayona',                      
      ],
      places: [
        'suksunskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-kamyshlova-i-kamyshlovskogo-rayona' => {  
    neighbors: {
      projects: [
        'bioraznoobrazie-irbita-i-irbitskogo-rayona',        
        'bioraznoobrazie-pyshminskogo-rayona',               
        'bioraznoobrazie-suholozhskogo-rayona',              
        'bioraznoobrazie-bogdanovichskogo-rayona',           
      ],
      places: [
        'dalmatovskiy-rayon',
        'katayskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-novolyalinskogo-rayona' => {      
    neighbors: {
      projects: [
        'bioraznoobrazie-serovskogo-rayona-sosva',   
        'bioraznoobrazie-verhoturskogo-rayona',      
        'bioraznoobrazie-serova',                    
        'bioraznoobrazie-krasnoturinska',            
        'bioraznoobrazie-nizhney-tury-i-lesnogo',    
        'bioraznoobrazie-karpinska-i-volchanska',    
      ],
      places: [
        'gornozavodskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-serova' => {                     
    neighbors: {
      projects: [
        'bioraznoobrazie-serovskogo-rayona-sosva',  
        'bioraznoobrazie-garinskogo-rayona',        
        'bioraznoobrazie-novolyalinskogo-rayona',   
        'bioraznoobrazie-ivdelya-i-pelyma',         
        'bioraznoobrazie-krasnoturinska',           
        'bioraznoobrazie-severouralska',            
        'bioraznoobrazie-karpinska-i-volchanska',   
      ],
      places: [],
    },
  },

  'bioraznoobrazie-kushvy-i-verhney-tury' => {       
    neighbors: {
      projects: [
        'bioraznoobrazie-krasnouralska',             
        'bioraznoobrazie-kachkanara',                
        'bioraznoobrazie-nizhney-tury-i-lesnogo',    
        'bioraznoobrazie-prigorodnogo-rayona',       
        'bioraznoobrazie-nizhnego-tagila',           
      ],
      places: [
        'gornozavodskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-verhoturskogo-rayona' => {                
    neighbors: {
      projects: [
        'bioraznoobrazie-serovskogo-rayona-sosva',           
        'bioraznoobrazie-krasnouralska',                     
        'bioraznoobrazie-novolyalinskogo-rayona',            
        'bioraznoobrazie-verhnesaldinskogo-rayona',          
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',  
        'bioraznoobrazie-nizhney-tury-i-lesnogo',            
      ],
      places: [],
    },
  },

  'bioraznoobrazie-nizhney-saldy' => {                      
    neighbors: {
      projects: [
        'bioraznoobrazie-verhnesaldinskogo-rayona',         
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona', 
      ],
      places: [],
    },
  },

  'bioraznoobrazie-taborinskogo-rayona' => {                
    neighbors: {
      projects: [
        'bioraznoobrazie-garinskogo-rayona',                
        'bioraznoobrazie-turinskogo-rayona',                
        'bioraznoobrazie-tavdinskogo-rayona',               
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona', 
      ],
      places: [
        'kondinskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-baykalovskogo-rayona' => {           
    neighbors: {
      projects: [
        'bioraznoobrazie-turinskogo-rayona',            
        'bioraznoobrazie-irbita-i-irbitskogo-rayona',   
        'bioraznoobrazie-talitskogo-rayona',            
        'bioraznoobrazie-slobodo-turinskogo-rayona',    
        'bioraznoobrazie-tugulymskogo-rayona',          
      ],
      places: [],
    },
  },

  'bioraznoobrazie-krasnouralska' => {              
    neighbors: {
      projects: [
        'bioraznoobrazie-verhoturskogo-rayona',     
        'bioraznoobrazie-kushvy-i-verhney-tury',    
        'bioraznoobrazie-verhnesaldinskogo-rayona', 
        'bioraznoobrazie-nizhney-tury-i-lesnogo',   
        'bioraznoobrazie-prigorodnogo-rayona',      
      ],
      places: [],
    },
  },

  'bioraznoobrazie-garinskogo-rayona' => {                   
    neighbors: {
      projects: [
        'bioraznoobrazie-serovskogo-rayona-sosva',           
        'bioraznoobrazie-taborinskogo-rayona',               
        'bioraznoobrazie-serova',                            
        'bioraznoobrazie-ivdelya-i-pelyma',                  
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',  
      ],
      places: [
        'kondinskiy-rayon',
      ],
    },
  },

  'bioraznoobrazie-serovskogo-rayona-sosva' => {             
    neighbors: {
      projects: [
        'bioraznoobrazie-garinskogo-rayona',                 
        'bioraznoobrazie-verhoturskogo-rayona',              
        'bioraznoobrazie-serova',                            
        'bioraznoobrazie-novolyalinskogo-rayona',            
        'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',  
      ],
      places: [],
    },
  },

}

ZONES = {
  'bioraznoobrazie-vostochnogo-okruga-sverdlovskoy-oblasti' => {
    short: '<img src="https://static.inaturalist.org/projects/180214-icon-span2.png" style="height:36px;vertical-align:bottom;"> Восточный округ',
    content: [
      'bioraznoobrazie-alapaevska-i-alapaevskogo-rayona',
      'bioraznoobrazie-artyomovskogo-rayona',
      'bioraznoobrazie-baykalovskogo-rayona',
      'bioraznoobrazie-irbita-i-irbitskogo-rayona',
      'bioraznoobrazie-kamyshlova-i-kamyshlovskogo-rayona',
      'bioraznoobrazie-pyshminskogo-rayona',
      'bioraznoobrazie-rezhevskogo-rayona',
      'bioraznoobrazie-slobodo-turinskogo-rayona',
      'bioraznoobrazie-taborinskogo-rayona',
      'bioraznoobrazie-tavdinskogo-rayona',
      'bioraznoobrazie-talitskogo-rayona',
      'bioraznoobrazie-tugulymskogo-rayona',
      'bioraznoobrazie-turinskogo-rayona',
    ],
  },
  'bioraznoobrazie-gornozavodskogo-okruga-sverdlovskoy-oblasti' => {
    short: '<img src="https://static.inaturalist.org/projects/180216-icon-span2.png" style="height:36px;vertical-align:bottom;"> Горнозаводской округ',
    content: [
      'bioraznoobrazie-verhnesaldinskogo-rayona',
      'bioraznoobrazie-kirovgrada-i-verhnego-tagila',
      'bioraznoobrazie-kushvy-i-verhney-tury',
      'bioraznoobrazie-nevyanskogo-rayona-i-novouralska',
      'bioraznoobrazie-nizhnego-tagila',
      'bioraznoobrazie-nizhney-saldy',
      'bioraznoobrazie-prigorodnogo-rayona',
    ],
  },
  'bioraznoobrazie-zapadnogo-okruga-sverdlovskoy-oblasti' => {
    short: '<img src="https://static.inaturalist.org/projects/180212-icon-span2.png" style="height:36px;vertical-align:bottom;"> Западный округ',
    content: [
      'bioraznoobrazie-artinskogo-rayona',
      'bioraznoobrazie-achitskogo-rayona',
      'bioraznoobrazie-verhney-pyshmy-i-sredneuralska',
      'bioraznoobrazie-krasnoufimska-i-krasnoufimskogo-rayona',
      'bioraznoobrazie-nizhneserginskogo-rayona',
      'bioraznoobrazie-pervouralska',
      'bioraznoobrazie-polevskogo',
      'bioraznoobrazie-shalinskogo-rayona',
      'bioraznoobrazie-revdy-i-degtyarska',
    ],
  },
  'bioraznoobrazie-severnogo-okruga-sverdlovskoy-oblasti' => {
    short: '<img src="https://static.inaturalist.org/projects/180218-icon-span2.png" style="height:36px;vertical-align:bottom;"> Северный округ',
    content: [
      'bioraznoobrazie-verhoturskogo-rayona',
      'bioraznoobrazie-garinskogo-rayona',
      'bioraznoobrazie-ivdelya-i-pelyma',
      'bioraznoobrazie-karpinska-i-volchanska',
      'bioraznoobrazie-kachkanara',
      'bioraznoobrazie-krasnoturinska',
      'bioraznoobrazie-krasnouralska',
      'bioraznoobrazie-nizhney-tury-i-lesnogo',
      'bioraznoobrazie-novolyalinskogo-rayona',
      'bioraznoobrazie-severouralska',
      'bioraznoobrazie-serova',
      'bioraznoobrazie-serovskogo-rayona-sosva',
    ],
  },
  'bioraznoobrazie-yuzhnogo-okruga-sverdlovskoy-oblasti' => {
    short: '<img src="https://static.inaturalist.org/projects/180213-icon-span2.png" style="height:36px;vertical-align:bottom;"> Южный округ',
    content: [
      'bioraznoobrazie-asbesta',
      'bioraznoobrazie-beloyarskogo-rayona',
      'bioraznoobrazie-beryozovskogo',
      'bioraznoobrazie-bogdanovichskogo-rayona',
      'bioraznoobrazie-zarechnogo',
      'bioraznoobrazie-kamenska-uralskogo-i-kamenskogo-rayona',
      'bioraznoobrazie-suholozhskogo-rayona',
      'bioraznoobrazie-sysertskogo-rayona',
    ],
  },
}

SPECIALS = {
  'mezhmunitsipalnoe-bioraznoobrazie-sverdlovskoy-oblasti' => {
  },
}
