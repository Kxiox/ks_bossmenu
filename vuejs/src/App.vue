<script setup>
  import { ref, onMounted } from 'vue'

  // import translations from '../public/en.json'

  // function t(key) {
  //   return key.split('.').reduce((o, i) => (o ? o[i] : key), translations)
  // }

  import bootstrap from 'bootstrap/dist/js/bootstrap.bundle.js'
  import HomeComponent from './components/HomeComponent.vue'
  import ActionsComponent from './components/ActionsComponent.vue'
  import EmployeesComponent from './components/EmployeesComponent.vue'
  import SalariesComponent from './components/SalariesComponent.vue'
  import AccountComponent from './components/AccountComponent.vue'
  import BonusComponent from './components/BonusComponent.vue'
  import TransactionsComponent from './components/TransactionsComponent.vue'
  import ModalsComponent from './components/ModalsComponent.vue'
  import NotifiesComponent from './components/NotifiesComponent.vue'

  const employeesAmount = ref(0)
  const onDuty = ref(0)
  const account = ref('0$')
  const currency = ref(null)
  const employeesList = ref([])
  const saleriesList = ref([])
  const actionsList = ref([])
  const transactionsList = ref([])
  const selectedSalary = ref(null) // <-- hinzufügen

  const showAllActions = ref(false)
  const fadeHome = ref(true)
  const fadeActions = ref(false)
  const notifiesRef = ref(null)

  const devMode = ref(true) // Set to true to show the color mode dropdown

  function showActions() {
    fadeHome.value = false
    setTimeout(() => {
      showAllActions.value = true
      setTimeout(() => {
        fadeActions.value = true
      }, 10)
    }, 150)
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

  const showAllTransactions = ref(false)
  const fadeAccount = ref(true)
  const fadeTransactions = ref(false)

  function showTransactions() {
    fadeAccount.value = false
    setTimeout(() => {
      showAllTransactions.value = true
      setTimeout(() => {
        fadeTransactions.value = true
      }, 10)
    }, 150)
  }

  function showAccount() {
    fadeTransactions.value = false
    setTimeout(() => {
      showAllTransactions.value = false
      setTimeout(() => {
        fadeAccount.value = true
      }, 10)
    }, 150)
  }

  function changeColorMode(color) {
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

  function openNUI() {
    const root = document.querySelector(':root');
    root.style.opacity = 0;
    root.style.display = 'block';
    setTimeout(() => {
      root.style.transition = 'opacity 0.15s';
      root.style.opacity = 1;
    }, 150);
  }

  function closeNUI() {
    const root = document.querySelector(':root');
    root.style.transition = 'opacity 0.15s';
    root.style.opacity = 0;
    setTimeout(() => {
      root.style.display = 'none';
      fetch(`https://${GetParentResourceName()}/closeNUI`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
          message: 'close'
        })
      })
    }, 150);
  }

  function handleOpenSalaryModal(salary) {
    selectedSalary.value = salary
    // Modal öffnen (Bootstrap)
    const modal = new bootstrap.Modal(document.getElementById('salaryModal'))
    modal.show()
  }

  onMounted(() => {
    window.addEventListener('message', (event) => {
      if (event.data.action === 'openNUI') {
        openNUI()
      } else if (event.data.action === 'getStats') {
        employeesAmount.value = event.data.employeesamount
        onDuty.value = event.data.ondutyamount
        account.value = event.data.account + event.data.currency
        
        changeColorMode(event.data.color)
        const logo = document.querySelector('.logo');
        if (event.data.logo.startsWith('http://') || event.data.logo.startsWith('https://')) {
          logo.src = event.data.logo;
        } else {
          logo.src = `./img/${event.data.logo}`;
        }
        
      } else if (event.data.action === 'getEmployeesList') {
        employeesList.value = event.data.employees
      
      } else if (event.data.action === 'getSalaries') {
        saleriesList.value = event.data.salaries

      } else if (event.data.action === 'getActions') {
        actionsList.value = event.data.actions

      } else if (event.data.action === 'getTransactions') {
        transactionsList.value = event.data.transactions
      
      } else if (event.data.action === 'getCurrency') {
        currency.value = event.data.currency

      }
    })
  })
</script>


<template>
  <ModalsComponent
    :currency="currency"
    :notifiesRef="notifiesRef"
    :selectedSalary="selectedSalary"
  />

  <NotifiesComponent :currency="currency" ref="notifiesRef"/>

  <div class="dropdown" v-if="devMode">
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
      <li><a class="dropdown-item" href="#" @click="changeColorMode('rose')">Rose</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('magenta')">Magenta</a></li>
      <li><a class="dropdown-item" href="#" @click="changeColorMode('brown')">Brown</a></li>
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
          <i class="bi bi-house-door me-2"></i> {{ $t('pages.home') }}
        </button>
        <button class="nav-link text-start" id="v-pills-employees-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-employees" type="button" role="tab" aria-controls="v-pills-employees"
          aria-selected="false">
          <i class="bi bi-people me-2"></i> {{ $t('pages.employees') }}
        </button>
        <button class="nav-link text-start" id="v-pills-salaries-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-salaries" type="button" role="tab" aria-controls="v-pills-salaries"
          aria-selected="false">
          <i class="bi bi-cash me-2"></i> {{ $t('pages.salaries') }}
        </button>
        <button class="nav-link text-start" id="v-pills-account-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-account" type="button" role="tab" aria-controls="v-pills-account"
          aria-selected="false">
          <i class="bi bi-bank me-2"></i> {{ $t('pages.account') }}
        </button>
        <button class="nav-link text-start" id="v-pills-bonus-tab" data-bs-toggle="pill"
          data-bs-target="#v-pills-bonus" type="button" role="tab" aria-controls="v-pills-bonus"
          aria-selected="false">
          <i class="bi bi-gift me-2"></i> {{ $t('pages.bonus') }} <span class="badge">New</span>
        </button>
      </div>

      <div class="tab-content" id="v-pills-tabContent">
        <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab"
          tabindex="0">
          <div v-if="!showAllActions" :class="['fade', { show: fadeHome }]">
            <HomeComponent :currency="currency" :actions="actionsList" :employees="employeesAmount" :onDuty="onDuty" :account="account"
              @see-all-actions="showActions" />
          </div>
          <div v-else :class="['fade', { show: fadeActions }]">
            <ActionsComponent :currency="currency" :actions="actionsList" @back-to-home="showHome" />
          </div>
        </div>
        <div class="tab-pane fade" id="v-pills-employees" role="tabpanel" aria-labelledby="v-pills-employees-tab"
          tabindex="0">

          <EmployeesComponent :notifiesRef="notifiesRef" :employees="employeesList"></EmployeesComponent>

        </div>
        <div class="tab-pane fade" id="v-pills-salaries" role="tabpanel" aria-labelledby="v-pills-salaries-tab"
          tabindex="0">

          <SalariesComponent :saleries="saleriesList" @open-salary-modal="handleOpenSalaryModal"/>

        </div>
        <div class="tab-pane fade" id="v-pills-account" role="tabpanel" aria-labelledby="v-pills-account-tab"
          tabindex="0">

          <div v-if="!showAllTransactions" :class="['fade', { show: fadeAccount }]">
            <AccountComponent :notifiesRef="notifiesRef" :currency="currency" :transactions="transactionsList" :account="account"
              @see-all-transactions="showTransactions" />
          </div>

          <div v-else :class="['fade', { show: fadeTransactions }]">
            <TransactionsComponent :transactions="transactionsList" @back-to-account="showAccount" />
          </div>
        </div>

        <div class="tab-pane fade" id="v-pills-bonus" role="tabpanel" aria-labelledby="v-pills-bonus-tab"
          tabindex="0">
          <BonusComponent :notifiesRef="notifiesRef" />
        </div>
      </div>
    </div>

    <button type="button" class="btn btn-sm btn-red closebtn" @click="closeNUI()"><i class="bi bi-x-lg"></i></button>

  </div>
</template>

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
    border-radius: 12px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    border: 1px solid var(--color-700);
    width: 50vw;
    height: 50vh;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: #fff;
    overflow: hidden;
  }

  .vr {
    width: 1px;
    background-color: var(--color-600);
    height: auto;
    align-self: stretch;
  }

  hr {
    border: 0;
    height: 1px;
    background: linear-gradient(90deg, 
      transparent 0%, 
      var(--color-600) 50%, 
      transparent 100%);
    margin: 1rem 0;
  }

  .nav {
    width: 20%;
    height: 50vh;
    gap: 8px;
    border-right: 1px solid var(--color-700);
    padding: 20px;
    background: linear-gradient(180deg, 
      var(--color-900) 0%, 
      var(--color-800) 100%);
  }

  .logo {
    width: 60%;
    height: auto;
    margin: 1rem auto;
    filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
  }

  .nav button {
    width: 100%;
    color: var(--color-200);
    border: 1px solid transparent;
    border-radius: 8px;
    font-weight: 600;
    text-align: left;
    padding: 0.75rem 1rem;
    font-size: 0.9rem;
    transition: all 0.3s ease;
    background: transparent;
    display: flex;
    align-items: center;
    position: relative;
    overflow: hidden;
  }

  .nav button::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 3px;
    background: var(--color-500);
    transform: scaleY(0);
    transition: transform 0.3s ease;
  }

  .nav button:hover {
    border: 1px solid var(--color-600);
    background: linear-gradient(135deg, 
      var(--color-800) 0%, 
      var(--color-700) 100%);
    color: #fff;
    transform: translateX(4px);
  }

  .nav button:hover::before {
    transform: scaleY(1);
  }

  .nav button.active {
    background: linear-gradient(135deg, 
      var(--color-700) 0%, 
      var(--color-600) 100%);
    border: 1px solid var(--color-500);
    color: #fff;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }

  .nav button.active::before {
    transform: scaleY(1);
  }

  .nav button i {
    color: var(--color-400);
    transition: color 0.3s ease;
  }

  .nav button:hover i,
  .nav button.active i {
    color: #fff;
  }

  .tab-content {
    width: 80%;
    height: 100%;
    padding: 20px;
    padding-left: 0;
    background: var(--color-900);
  }

  .closebtn {
    position: absolute;
    top: 20px;
    right: 20px;
    color: white;
    z-index: 10;
  }

  .badge {
    font-weight: 600 !important;
    padding: 0.25rem 0.5rem !important;
    border-radius: 4px !important;
    font-size: 0.7rem !important;
    margin-left: 0.5rem !important;
  }
</style>