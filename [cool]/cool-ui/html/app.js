function changeTab(tabName) {
    const tabs = document.querySelectorAll('.tab-content');
    tabs.forEach(tab => tab.style.display = 'none');
    
    const activeTab = document.getElementById(tabName);
    activeTab.style.display = 'block';

    const buttons = document.querySelectorAll('.tab-button');
    buttons.forEach(button => button.classList.remove('active'));
    
    const activeButton = document.querySelector(`button[onclick="changeTab('${tabName}')"]`);
    activeButton.classList.add('active');
}

// Function to show or hide the UI elements
function toggleUI(elementId, action) {
    const uiElement = document.getElementById(elementId);
    if (action === 'show') {
        uiElement.style.display = 'block';
    } else if (action === 'hide') {
        uiElement.style.display = 'none';
    }
}

// Initialize the first tab as active by default
document.addEventListener('DOMContentLoaded', function() {
    changeTab('overview');
});

// Replace with this code in your `app.js`

window.addEventListener('message', function(event) {
    if (event.data.action === 'toggleSmallUI') {
        toggleUI('smallUI', event.data.data.show ? 'show' : 'hide');
    }

    if (event.data.action === 'toggleMediumUI') {
        toggleUI('mediumUI', event.data.data.show ? 'show' : 'hide');
    }

    if (event.data.action === 'toggleLargeUI') {
        toggleUI('largeUI', event.data.data.show ? 'show' : 'hide');
    }
});