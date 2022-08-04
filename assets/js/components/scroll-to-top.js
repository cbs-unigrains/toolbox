const template = document.createElement("template");
template.innerHTML = `
<style>
:host {
    position: fixed;
    bottom: 20px;
    right: 20px;
    display: block;
  }

    button, [role="button"] {
        -webkit-appearance: button;
        background-image: none;
        cursor: pointer;
        text-transform: none;
        font-family: inherit;
    }
    .h-6 { width: 1.5rem; }
    .w-6 { width: 1.5rem; }
    
    .text-indigo-700 {
        --tw-text-opacity: 1;
        color: rgb(67 56 202 / var(--tw-text-opacity));
    }
    .font-medium { font-weight: 500; }
    .text-xs {
        font-size: 0.75rem;
        line-height: 1rem;
    }
    .py {
        padding-top: 0.375rem;
        padding-bottom: 0.375rem;
    }
    .px {
        padding-left: 0.625rem;
        padding-right: 0.625rem;
    } 

    .border-transparent { border-color: transparent; }
    .border { border-width: 1px; }
    .rounded { border-radius: 0.25rem; }
    .items-center { align-items: center; }
    .inline-flex { display: inline-flex; }

    .bg-indigo:hover {
        background-color: rgb(199 210 254 / 1);
    }
    .bg-indigo {
        background-color: rgb(224 231 255 / 1);
    }

   
</style>
<button id="scroll" type="button" class="inline-flex items-center px py border border-transparent text-xs font-medium rounded text-indigo-700 bg-indigo">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18" />
    </svg>
</button>
`;

class ScrollToTop extends HTMLElement {
    constructor() {
        super();
        this.attachShadow({ mode: 'open' });
    }
    connectedCallback() {
        this.shadowRoot.appendChild(template.content.cloneNode(true));
        this.shadowRoot.getElementById('scroll').onclick = () => this.scrollToTop();
    }
    scrollToTop() {
        window.scrollTo({ top: 0, behavior: "smooth" });
    }
}

customElements.define('scroll-to-top', ScrollToTop);