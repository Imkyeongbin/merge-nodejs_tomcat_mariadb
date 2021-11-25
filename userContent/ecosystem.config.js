module.exports = {

    apps : [{
  
      name: 'UI1',
  
      exec_mode: 'cluster',
  
      instances: 0,
  
      script: '/nodeApp/node_modules/nuxt/bin/nuxt.js',
  
      args: 'start',
  
      //watch: '.',
  
      env:{
  
        HOST: '0.0.0.0',
  
      },
      cwd: '/nodeApp',
  
   },{
  
    name: 'UI0',
  
    //exec_mode: 'cluster',
  
    //instances: 3,
  
    script: '/nodeApp/node_modules/nuxt/bin/nuxt.js',
  
    args: 'start',
  
    //watch: '.',
  
    env:{
  
      HOST: '0.0.0.0',
  
    },
    cwd: '/nodeApp',
  }],
  
};