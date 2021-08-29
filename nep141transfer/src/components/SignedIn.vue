<template>
  <div>
    <button class="link" style="float: right" v-on:click="logout">Sign out</button>
    <main>
      <h1>
        {{ accountId }}
      </h1>
      <form v-on:submit.prevent="addToken">
        <fieldset ref="add_token">
          <label
            for="greeting"
            style="display:block; color:var(--gray);margin-bottom:0.5em;"
          >Add Token</label>
          <div style="display:flex">
            <input v-model="newToken" autocomplete="off" id="greeting" style="flex:1" />
            <button style="border-radius:0 5px 5px 0">add</button>
          </div>
        </fieldset>
      </form>
      <form v-on:submit.prevent="transfer">
        <fieldset ref="transfer">
          <label
            for="greeting"
            style="display:block; color:var(--gray);margin-bottom:0.5em;margin-top: 20px"
          >To</label>
          <div style="display:flex">
            <input v-model="to" autocomplete="off" id="greeting" style="flex:1" />
          </div>
          <label
            for="greeting"
            style="display:block; color:var(--gray);margin-bottom:0.5em;margin-top: 20px"
          >Amount</label>
          <div style="display:flex">
            <input v-model="amount" autocomplete="off" id="greeting" style="flex:1" />
          </div>
          <label
            for="greeting"
            style="display:block; color:var(--gray);margin-bottom:0.5em;margin-top: 20px"
          >Select Token</label>
          <select v-model="token">
            <option v-for="t in tokenList" :key="t">{{t}}</option>
          </select>
          <div style="display:flex;justify-content: center">
            <button style="border-radius:5px 5px 5px 5px;margin-top: 20px">transfer</button>
          </div>
        </fieldset>
      </form>
      <hr />
    </main>

    <Notification
      v-show="notificationVisible"
      ref="notification"
      :networkId="networkId"
      :msg="'called method: set_greeting'"
      :contractId="contractId"
      :visible="false"
    />
  </div>
</template>

<script>
import { logout, to_yocto } from "../utils"

import Notification from "./Notification.vue"
const GAS = "300000000000000";

export default {
  name: "SignedIn",

  beforeMount() {
    if (this.isSignedIn) {
      this.getTokenList()
    }
  },

  components: {
    Notification,
  },

  data: function () {
    return {
      tokenList: [],
      newToken: "",
      notificationVisible: false,
      to: '',
      amount: '',
      token: '',
    }
  },

  computed: {
    isSignedIn() {
      return window.walletConnection? window.walletConnection.isSignedIn(): false
    },
    accountId() {
      return window.accountId
    },
    contractId() {
      return window.contract? window.contract.contractId: null
    },
    networkId() {
      return window.networkId
    },
  },

  methods: {
    getTokenList() {
      //retrieve greeting
      window.contract
        .list()
        .then((result) => {
          this.tokenList = result
          if (this.tokenList.length > 0) {
            this.token = this.tokenList[0]
          }
        })
    },

    async addToken () {
      // fired on form submit button used to update the greeting

      // disable the form while the value gets updated on-chain
      this.$refs.add_token.disabled = true

      try {
        await window.contract.add({
          fungible_token_account_id: this.newToken
        })
      } catch (e) {
        alert(
          "Something went wrong! " +
            "Maybe you need to sign out and back in? " +
            "Check your browser console for more info."
        )
        throw e //re-throw
      } finally {
        // re-enable the form, whether the call succeeded or failed
        this.$refs.add_token.disabled = false
      }

      this.notificationVisible = true //show new notification
      this.getTokenList()
      // remove Notification again after css animation completes
      // this allows it to be shown again next time the form is submitted
      setTimeout(() => {
        this.notificationVisible = false
      }, 11000)

    },

    async transfer() {
      this.$refs.transfer.disabled = true
      try {
        window.contract.transfer({receiver_id: this.to, amount: to_yocto(this.amount), fungible_token_account_id: this.token}, GAS, to_yocto(this.amount))
      } catch (e) {
        alert(
          "Something went wrong! " +
            "Maybe you need to sign out and back in? " +
            "Check your browser console for more info."
        )
        throw e //re-throw
      } finally {
        // re-enable the form, whether the call succeeded or failed
        this.$refs.add_token.disabled = false
      }
      
      this.$refs.transfer.disabled = false
      // near call  ${nep1_contract_id}  ft_transfer_call   '{"receiver_id":"'${defi_contract_id}'","amount":"1000000000000000000000000","msg":"200000000000000000000000"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 
    },

    logout: logout,
  },
}
</script>
