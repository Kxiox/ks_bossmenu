<script setup>
  import { ref } from 'vue'
  import HomeComponent from './components/HomeComponent.vue'
  import ActionsComponent from './components/ActionsComponent.vue'
  import EmployeesComponent from './components/EmployeesComponent.vue'
  import SalariesComponent from './components/SalariesComponent.vue'
  import AccountComponent from './components/AccountComponent.vue'

  const showAllActions = ref(false)
  const fadeHome = ref(true)
  const fadeActions = ref(false)

  function showActions() {
    fadeHome.value = false
    setTimeout(() => {
      showAllActions.value = true
      // WICHTIG: Erst nach dem Rendern das Fade-In triggern!
      setTimeout(() => {
        fadeActions.value = true
      }, 10)
    }, 150) // match Bootstrap's fade duration
  }
  function showHome() {
    fadeActions.value = false
    setTimeout(() => {
      showAllActions.value = false
      setTimeout(() => {
        fadeHome.value = true
      }, 10)
    }, 150)
  }
</script>

<template>
  <div class="dropdown">
    <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
      Color mode
    </button>
    <ul class="dropdown-menu dropdown-menu-dark">
      <li><a class="dropdown-item" href="#" @click="changeColorMode('blue')">Blue</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('indigo')">Indigo</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('purple')">Purple</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('pink')">Pink</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('red')">Red</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('orange')">Orange</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('yellow')">Yellow</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('green')">Green</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('teal')">Teal</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('cyan')">Cyan</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('light')">Light</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('dark')">Dark</a></li>
    </ul>
  </div>

  <div class="dashboard">
    <div class="d-flex align-items-start">
      <div class="nav flex-column nav-pills me-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
        <img src="./assets/logo.svg" alt="" class="logo">
        <hr>
        <button class="nav-link text-start active" id="v-pills-home-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-home" type="button" role="tab" aria-controls="v-pills-home" aria-selected="true">
          <i class="bi bi-house-door me-2"></i> Home
        </button>
        <button class="nav-link text-start" id="v-pills-employees-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-employees" type="button" role="tab" aria-controls="v-pills-employees"
          aria-selected="false">
          <i class="bi bi-people me-2"></i> Employees
        </button>
        <button class="nav-link text-start" id="v-pills-salaries-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-salaries" type="button" role="tab" aria-controls="v-pills-salaries"
          aria-selected="false">
          <i class="bi bi-cash me-2"></i> Salaries
        </button>
        <button class="nav-link text-start" id="v-pills-account-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-account" type="button" role="tab" aria-controls="v-pills-account"
          aria-selected="false">
          <i class="bi bi-bank me-2"></i> Account
        </button>
      </div>
      <!-- <div class="vr"></div> -->
      <div class="tab-content" id="v-pills-tabContent">
        <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab"
          tabindex="0">
          <div v-if="!showAllActions" :class="['fade', { show: fadeHome }]">
            <HomeComponent @see-all="showActions" />
          </div>
          <div v-else :class="['fade', { show: fadeActions }]">
            <ActionsComponent @back="showHome" />
          </div>
        </div>
        <div class="tab-pane fade" id="v-pills-employees" role="tabpanel" aria-labelledby="v-pills-employees-tab"
          tabindex="0">

          <EmployeesComponent></EmployeesComponent>

        </div>
        <div class="tab-pane fade" id="v-pills-salaries" role="tabpanel" aria-labelledby="v-pills-salaries-tab"
          tabindex="0">
        
          <SalariesComponent></SalariesComponent>

        </div>
        <div class="tab-pane fade" id="v-pills-account" role="tabpanel" aria-labelledby="v-pills-account-tab"
          tabindex="0">
        
          <AccountComponent></AccountComponent>

        </div>
      </div>
    </div>

    <button type="button" class="btn btn-sm btn-danger closebtn"><i class="bi bi-x-lg"></i></button>
    
    </div>
</template>

<script>
   export default {
    data() {
      return {
        message: 'Waiting for message from FiveM client...'
      }
    },
    mounted() {
      window.addEventListener('message', (event) => {
        if (event.data.action === 'showMessage') {
          this.message = event.data.message
          console.log(this.message)
        }
      })
    },
    methods: {
      sendMessage() {
        fetch(`https://${GetParentResourceName()}/exampleCallback`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: JSON.stringify({
            message: 'Hello from Vue.js!'
          })
        }).then(response => response.json())
          .then(data => {
            console.log('Response from FiveM client:', data)
          })
      },
      changeColorMode(color) {
        document.documentElement.style.setProperty('--color-default', `var(--kxiox-${color}-500)`);
        document.documentElement.style.setProperty('--color-100', `var(--kxiox-${color}-100)`);
        document.documentElement.style.setProperty('--color-200', `var(--kxiox-${color}-200)`);
        document.documentElement.style.setProperty('--color-300', `var(--kxiox-${color}-300)`);
        document.documentElement.style.setProperty('--color-400', `var(--kxiox-${color}-400)`);
        document.documentElement.style.setProperty('--color-500', `var(--kxiox-${color}-500)`);
        document.documentElement.style.setProperty('--color-600', `var(--kxiox-${color}-600)`);
        document.documentElement.style.setProperty('--color-700', `var(--kxiox-${color}-700)`);
        document.documentElement.style.setProperty('--color-800', `var(--kxiox-${color}-800)`);
        document.documentElement.style.setProperty('--color-900', `var(--kxiox-${color}-900)`);
      }
    }
   }
</script>

<style scoped lang="scss">
  @use 'bootstrap/scss/bootstrap' as *;

  .dropdown {
    position: absolute;
    top: 20px;
    left: 20px;
    z-index: 1000;
  }

  .dashboard {
    background: var(--color-900);
    // padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    width: 50vw;
    height: 50vh;

    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);

    color: #fff;

    .vr {
        width: 1px;
        background-color: #ccc;
        height: auto;
        align-self: stretch;
    }

    hr {
      border: 0;
      height: 1px;
      background-color: #ccc;
    }

    .nav {
      width: 20%;
      height: 50vh;
      gap: 15px;

      border-right: 1px solid #cccccc30;
      padding: 20px;

      .logo {
        width: 30%;
        height: auto;
        margin-top: 20px;
        margin-left: auto;
        margin-right: auto;
      }

      button {
        width: 100%;
        // background-color: #444;
        color: #fff;
        border: none;
        border-radius: 5px;
        font-weight: bold;
        text-align: left;
        padding-left: 20px;

        &:hover {
          background-color: var(--color-800);
          cursor: pointer;
        }

        &.active {
          background-color: var(--color-500);
          color: #fff;
          font-weight: bold;
        }
      }
    }

    .tab-content {
        width: 80%;
        height: 100%;
        padding: 20px;
        padding-left: 0;
    }

    .closebtn {
        position: absolute;
        top: 20px;
        right: 20px;
        color: white;
    }
  }
</style>