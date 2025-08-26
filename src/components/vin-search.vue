<script setup>
    import { ref } from 'vue'
    import axios from 'axios'
    import { useRouter } from 'vue-router'

    const inputVin = ref('')
    const apiError = ref(false)
    const router = useRouter()

    function submitSearch() {
        if (!inputVin.value) return
        axios.get(`http://localhost:8080/api/vin/${inputVin.value}`).then(response => {
            if (response.status !== 200) {
                throw new Error('Not found')
            }
            apiError.value = false
            router.push(`/vin/${inputVin.value}`)
        }).catch(error => {
            console.log(error)
            apiError.value = true
            inputVin.value = ''
        })
    }
</script>

<template>
    <div class="container-fluid d-flex justify-content-center flex-column w-25">
        <input class="form-control text-center" type="text" v-model="inputVin" placeholder="FIN" v-on:keyup.enter="submitSearch">
        <button
          type="button"
          class="btn submit-btn btn-md mt-3 w-100"
          @click="submitSearch"
          aria-label="Search VIN"
        >
          Suchen
        </button>
        <p class="text-danger pt-2" v-if="apiError">Nicht gefunden</p>
    </div>
</template>

<style scoped>
/* thicker, styled search input */
.container-fluid input.form-control {
  border-width: 2.5px;
  border-style: solid;
  border-color: #0b5ed7;
  border-radius: 0.5rem;
  padding: 0.5rem 0.75rem;
  transition: box-shadow .12s ease, transform .08s ease, border-color .12s ease;
}

/* focus state: glow and slight lift */
.container-fluid input.form-control:focus {
  outline: none;
  box-shadow: 0 8px 24px rgba(11,94,215,0.12);
  transform: translateY(-1px);
  border-color: #0a58ca;
}

/* existing submit button styles */
.submit-btn {
  background: linear-gradient(90deg, #0d6efd, #0b5ed7);
  border: none;
  border-radius: 999px;
  box-shadow: 0 8px 20px rgba(11,94,215,0.15);
  color: #fff;
  font-weight: 600;
  transition: transform .15s ease, filter .15s ease;
}

.submit-btn:hover {
  filter: brightness(0.96);
  transform: translateY(-2px);
}

.submit-btn:active {
  transform: translateY(0);
}
</style>