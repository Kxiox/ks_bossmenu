<script setup>
    import { getCurrentInstance } from 'vue';
    const { proxy } = getCurrentInstance()
    const $t = proxy.$t
</script>

<template>
    <h1 class="text-start">{{ $t('pages.bonus') }}</h1>
    
    <hr />

    <div class="bonus-container">
        <div class="bonus-grid">
            <div class="bonus-card">
                <div class="card-header">
                    <i class="bi bi-person"></i>
                    <span>Einzelpersonen</span>
                </div>
                <button class="btn btn-main" type="button">
                    <i class="bi bi-person-plus"></i>
                    Bonus an Mitarbeiter
                </button>
            </div>

            <div class="bonus-card">
                <div class="card-header">
                    <i class="bi bi-diagram-3"></i>
                    <span>Ränge</span>
                </div>
                <button class="btn btn-main" type="button">
                    <i class="bi bi-award"></i>
                    Bonus an Ränge
                </button>
            </div>
        </div>

        <!-- Gruppen Card - Volle Breite -->
        <div class="bonus-card group full-width">
            <div class="card-header">
                <i class="bi bi-people"></i>
                <span>Gruppen</span>
            </div>
            <div class="card-actions horizontal">
                <button class="btn btn-main" type="button">
                    <i class="bi bi-people-fill"></i>
                    Alle Mitarbeiter
                </button>
                <button class="btn btn-main" type="button">
                    <i class="bi bi-diagram-2"></i>
                    Alle Ränge
                </button>
                <button class="btn btn-main online" type="button">
                    <i class="bi bi-wifi"></i>
                    Online Mitarbeiter
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
        text-align: center;
    }

    .bonus-container {
        padding: 0.75rem;
        max-width: 100%;
    }

    .bonus-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 0.75rem;
        margin-bottom: 0.75rem;
    }

    .full-width {
        width: 100%;
    }

    .bonus-card {
        background: var(--color-800);
        border-radius: 8px;
        border: 1px solid var(--color-700);
        overflow: hidden;
        transition: all 0.2s ease;

        &:hover {
            border-color: var(--color-500);
        }

        .card-header {
            background: var(--color-600);
            padding: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            font-weight: 600;
            color: #fff;
            
            i {
                font-size: 1rem;
                color: #fff;
            }
        }

        .card-actions {
            padding: 0.75rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;

            &.horizontal {
                flex-direction: row;
                flex-wrap: wrap;
                gap: 0.5rem;
                
                .btn-main {
                    flex: 1;
                    min-width: 200px;
                }
            }
        }

        .btn-main:not(.card-actions .btn-main) {
            margin: 0.75rem;
            width: calc(100% - 1.5rem); // Volle Breite minus margin
        }
    }

    .form-check-input[type="checkbox"] {
        background-color: var(--color-800);
        border: var(--color-400) 1px solid;
        width: 2.5rem;
        height: 1.25rem;
        
        &:checked {
            background-color: var(--color-500);
            border-color: var(--color-400);
        }
    }

    ::-webkit-scrollbar {
        width: 0.2rem;
        height: 0.2rem;
    }
        
    ::-webkit-scrollbar-thumb {
        background: var(--color-500);
        border-radius: 10px;
    }

    ::-webkit-scrollbar-track {
        background: var(--color-800);
    }

    @media (max-width: 768px) {
        .bonus-grid {
            grid-template-columns: 1fr;
        }
        
        .bonus-container {
            padding: 0.5rem;
        }
    }
</style>