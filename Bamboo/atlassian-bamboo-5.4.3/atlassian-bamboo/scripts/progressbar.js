//
// A javascript progress bar, to report progress of long running tasks
//

function ProgressBar(numberOfCells, taskId) {
    this.numberOfCells = numberOfCells;
    this.increment = 100 / numberOfCells;
    this.centerCell;
    this.taskId = taskId;

    this.renderProgressBar = renderProgressBar;
    this.showProgressComplete = showProgressComplete;

    this.renderProgressBar();
    this.showProgressComplete(0);
}


function renderProgressBar() {
    var tableText = "";
    for (x = 0; x < this.numberOfCells; x++) {
        tableText += '<td id="progress_' + x + '" width="10" height="10"/>';
        if (x == (this.numberOfCells / 2)) {
            centerCellName = "progress_" + x;
        }
    }

    $("ProgressBar").innerHTML = '<table class="ProgressBar" width="100%" border="0" cellspacing="0" cellpadding="0"><tr>' + tableText + '</tr></table>';
    this.centerCell = $(centerCellName);
}


function showProgressComplete(percentageComplete) {
    this.centerCell.innerHTML = percentageComplete + "%";
    for (x = 0; x < this.numberOfCells; x++) {
        var cell = $("progress_" + x);
        if ((cell) && ((percentageComplete == 0) || (percentageComplete / x < this.increment))) {
            cell.style.backgroundColor = "gray";
        } else {
            cell.style.backgroundColor = "#869A94";
        }
    }
}