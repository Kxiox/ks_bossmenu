<template>
    <h1 class="text-start">Account</h1>

    <hr>

    <div class="container text-center">
        <div class="row">
            <div class="col">Firmenkontostand</div>
            <div class="col">col</div>
            <div class="col">col</div>
            <div class="col">col</div>
        </div>
        <div class="row">
            <div class="col-8 barchart"><BarChart /></div>
            <div class="col-4">col-4</div>
        </div>
    </div>

    <!-- <div class="row">
        <div class="col">
            <div class="stats-section">
                <div class="container">
                    <div class="row g-0">
                        <div class="col-6 col-md-1">
                            <i class="bi bi-bank" style="font-size: 225%;"></i>
                        </div>

                        <div class="col-sm-6 col-md-8">
                            <h5>Account:</h5>
                            <h6>4.331.344.333€</h6>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> -->
</template>

<script>
    import BarChart from '@/components/BarChart.vue';

    export default {
        name: 'App',
        components: { BarChart }
    }
</script>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
        text-align: center;
    }

    .stats-section,
    .additional-info {
        // background-color: #ffffff10;
        border-radius: 1rem;
        padding: 1rem;
        color: var(--color-500);

        h5 {
            color: white;
        }
        
    }

    .barchart {
        width: 70%;
        height: 70%;
        background-color: var(--color-800);
        padding: 1rem;
        border-radius: 0.5rem;
    }
</style>